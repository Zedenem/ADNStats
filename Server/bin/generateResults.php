#!/usr/bin/php -d include_path=.:..:../Libraries:/usr/share/php:
<?php

require_once 'DCSSettings.php';

$settings = new DCSSettings();

$db = new mysqli($settings->dbHost, $settings->dbUser, $settings->dbPass, $settings->dbName, 3306);
if ($db->connect_errno)
{
  echo "Failed to connect to MySQL: (" . $db->connect_errno . ") " . $db->connect_error;
  return;
}

/*
$results['hour']['top_talkers'] = array(
  array('username' => 'talker1', 'posts' => 100),
  array('username' => 'talker2', 'posts' => 99),
  array('username' => 'talker3', 'posts' => 88),
  array('username' => 'talker4', 'posts' => 77),
  array('username' => 'talker5', 'posts' => 66));

$results['hour']['top_mentions'] = array(
  array('username' => 'mention1', 'posts' => 100),
  array('username' => 'mention2', 'posts' => 99),
  array('username' => 'mention3', 'posts' => 88),
  array('username' => 'mention4', 'posts' => 77),
  array('username' => 'mention5', 'posts' => 66));

$results['hour']['top_hashtags'] = array(
  array('username' => 'hashtag1', 'posts' => 100),
  array('username' => 'hashtag2', 'posts' => 99),
  array('username' => 'hashtag3', 'posts' => 88),
  array('username' => 'hashtag4', 'posts' => 77),
  array('username' => 'hashtag5', 'posts' => 66));

$results['hour']['top_posts'] = array(
  array('id' => 1, 'username' => 'user1', 'post' => 'post 1'),
  array('id' => 2, 'username' => 'user2', 'post' => 'post 2'),
  array('id' => 3, 'username' => 'user3', 'post' => 'post 3'),
  array('id' => 4, 'username' => 'user4', 'post' => 'post 4'),
  array('id' => 5, 'username' => 'user5', 'post' => 'post 5'));

$results['hour']['post_count'] = 1234;
$results['hour']['post_length'] = 99.9;
$results['hour']['unique_users'] = 555;

$results['hour']['sources'] = array(
  array('id' => 1, 'source' => 'source 1', 'posts' => 100),
  array('id' => 1, 'source' => 'source 2', 'posts' => 99),
  array('id' => 1, 'source' => 'source 3', 'posts' => 98),
  array('id' => 1, 'source' => 'source 4', 'posts' => 97),
  array('id' => 1, 'source' => 'source 5', 'posts' => 96),
  array('id' => 1, 'source' => 'source 6', 'posts' => 95),
  array('id' => 1, 'source' => 'source 7', 'posts' => 94),
  array('id' => 1, 'source' => 'source 8', 'posts' => 93),
  array('id' => 1, 'source' => 'source 9', 'posts' => 92));

$results['day'] = $results['hour'];

$results['updated'] = time();

echo json_encode($results);
*/

function statsSince($seconds)
{
  global $db;

  $results = array();
  $postIds = array();
  $topUsernames = array();
  $topTalkers = array();
  $topClients = array();
  $topMentions = array();
  $topSources = array();
  $topMentionedUsers = array();
  $topHashtags = array();
  $topPosts = array();

  $charCount = 0;
  $userCount = 0;

  $pastGMDate = gmdate('Y-m-d H:i:s', time() - $seconds);
  $postsQuery = $db->query(sprintf("select * from `posts` where `create_date` > '%s';", $pastGMDate));
  while ($postsResult = $postsQuery->fetch_assoc())
  {
    $postIds[] = $postsResult['id'];
    $userIdKey = $postsResult['user_id'];
    $sourceIdKey = $postsResult['source_id'];
    $postIdKey = $postsResult['id'];
    $charCount += strlen($postsResult['message']);

    if (isset($topUsernames[$userIdKey]))
    {
      $topUsernames[$userIdKey] += 1;
    }
    else
    {
      $topUsernames[$userIdKey] = 1;
      ++$userCount;
    }

    if (isset($topSources[$sourceIdKey]))
    {
      $topSources[$sourceIdKey] += 1;
    }
    else
    {
      $topSources[$sourceIdKey] = 1;
    }

    if (isset($topPosts[$postIdKey]))
    {
      $topPosts[$postIdKey] += $postsResult['replys'] + $postsResult['stars'] + $postsResult['reposts'];
    }
    else
    {
      $topPosts[$postIdKey] = $postsResult['replys'] + $postsResult['stars'] + $postsResult['reposts'];
    }

    // DW: echo sprintf("%d -> %s\r\n", $postsResult['id'], $postsResult['message']);
  }

  $results['unique_users'] = $userCount;

  $results['post_count'] = count($postIds);
  if ($results['post_count'])
  {
    $results['post_length'] = $charCount / $results['post_count'];
  }
  else
  {
    $results['post_length'] = 0;
  }

  // DW: Get Top Talkers
  arsort($topUsernames);
  $i = 0;
  foreach ($topUsernames as $key => $value)
  {
    $userIdQuery = $db->query("select `id`, `name` from `users` where `id` = '" . $key . "';");
    $userIdResult = $userIdQuery->fetch_assoc();
    if ($userIdResult)
    {
      $topTalkers[] = array('id' => $userIdResult['id'], 'username' => $userIdResult['name'], 'posts' => $value);
      ++$i;
    }
    if ($i > 4) break;
  }
  $results['top_talkers'] = $topTalkers;

  // DW: Get Top Sources
  arsort($topSources);
  $i = 0;
  foreach ($topSources as $key => $value)
  {
    $sourceIdQuery = $db->query("select `id`, `client_id`, `name` from `sources` where `id` = '" . $key . "';");
    $sourceIdResult = $sourceIdQuery->fetch_assoc();
    if ($sourceIdResult)
    {
      $topClients[] = array('id' => $sourceIdResult['client_id'], 'source' => $sourceIdResult['name'], 'posts' => $value);
      ++$i;
    }
    if ($i > 4) break;
  }
  $results['top_sources'] = $topClients;

  // DW: Get Top Posts
  arsort($topPosts);
  $i = 0;
  foreach ($topPosts as $key => $value)
  {
    $postQuery = $db->query("select `id`, `user_id`, `message` from `posts` where `id` = '" . $key . "';");
    $postResult = $postQuery->fetch_assoc();
    if ($postResult)
    {
      $username = '';
      $userIdQuery = $db->query("select `id`, `name` from `users` where `id` = '" . $postResult['user_id'] . "';");
      $userIdResult = $userIdQuery->fetch_assoc();
      if ($userIdResult)
      {
        $username = $userIdResult['name'];
      }

      $topMessages[] = array('id' => $key, 'username' => $username, 'post' => $postResult['message']);
      ++$i;
    }
    if ($i > 4) break;
  }
  $results['top_posts'] = $topMessages;

  // DW: Get Top Mentions
  $postQueryString = implode(', ', $postIds);
  $postMentionsQuery = $db->query("select * from `post_mentions` where `post_id` in (" . $postQueryString . ");");
  while ($postMentionsResult = $postMentionsQuery->fetch_assoc())
  {
    $mentionKey = $postMentionsResult['mention_id'];
    if (isset($topMentions[$mentionKey]))
    {
      $topMentions[$mentionKey] += 1;
    }
    else
    {
      $topMentions[$mentionKey] = 1;
    }
  }
  arsort($topMentions);
  $i = 0;
  foreach ($topMentions as $key => $value)
  {
    $userIdQuery = $db->query("select `id`, `name` from `users` where `id` = '" . $key . "';");
    $userIdResult = $userIdQuery->fetch_assoc();
    if ($userIdResult)
    {
      $topMentionedUsers[] = array('username' => $userIdResult['name'], 'posts' => $value);
      ++$i;
    }
    if ($i > 4) break;
  }
  $results['top_mentions'] = $topMentionedUsers;

  // DW: Get Top Hashtags
  $postHashtagsQuery = $db->query("select * from `post_hashtags` where `post_id` in (" . $postQueryString . ");");
  while ($postHashtagsResult = $postHashtagsQuery->fetch_assoc())
  {
    $hashtagKey = $postHashtagsResult['hashtag_id'];
    if (isset($topHashs[$hashtagKey]))
    {
      $topHashs[$hashtagKey] += 1;
    }
    else
    {
      $topHashs[$hashtagKey] = 1;
    }
  }
  arsort($topHashs);
  $i = 0;
  foreach ($topHashs as $key => $value)
  {
    $hashtagIdQuery = $db->query("select `id`, `hashtag` from `hashtags` where `id` = '" . $key . "';");
    $hashtagIdResult = $hashtagIdQuery->fetch_assoc();
    if ($hashtagIdResult)
    {
      $topHashtags[] = array('hashtag' => $hashtagIdResult['hashtag'], 'posts' => $value);
      ++$i;
    }
    if ($i > 4) break;
  }
  $results['top_hashtags'] = $topHashtags;

  return $results;
}

while(true)
{
  // DW: $results['minute'] = statsSince(60);
  // DW: $results['ten_minutes'] = statsSince(600);
  $results['hour'] = statsSince(60*60);
  $results['day'] = statsSince(60*60*24);
  $results['updated'] = gmdate('U');

  // DW: echo print_r($results, true) . "\r\n";
  // DW: echo json_encode($results) . "\r\n";
  file_put_contents($settings->demoFile, json_encode($results));

  sleep(5);
}