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

// Get stream id
$streamIdQuery = $db->query("select `key`, `value` from `settings` where `key` = 'streamId';");
$streamIdResult = $streamIdQuery->fetch_assoc();
$streamId = $streamIdResult['value'];

$adn = new AppDotNet($settings->clientId, $settings->clientSecret);
$token = $adn->getAppAccessToken();

if ($streamId > 0)
{
  $stream = $adn->getStream($streamId);
}
else
{
  $stream = $adn->createStream(array('post', 'star'));

  // DW: Save our stream id to the database
  $db->query("update `settings` set `value`='" . $stream['id'] . "' where `key` = 'streamId';");
  $db->query("update `settings` set `value`='" . $stream['endpoint'] . "' where `key` = 'streamEndPoint';");
}

// print 'App Token: ' . $token . "\r\n";
// print 'Stream Id: ' . $stream['id'] . "\r\n";
// print 'Stream Endpoint: ' . $stream['endpoint'] . "\r\n";

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


// we need to create a callback function that will do something with posts/stars
// when they're received from the stream. This function should accept one single
// parameter that will be the php object containing the meta / data for the event.

/*
    [meta] => Array
        (
            [timestamp] => 1352147672891
            [type] => post/star/etc...
            [id] => 1399341
        )
    // data is as you would expect it
*/
function handleEvent($event)
{
  global $db;

  // DW: $json = json_encode($event['data']);
  // DW: print $json . "\n\n";

  // DW: print_r($event);
  // DW: return;

  if (!isset($event['data']) || !isset($event['meta']))
  {
    // DW: Skip this, no data
    return;
  }

  if (isset($event['meta']['type']))
  {
    switch ($event['meta']['type'])
    {
      case 'post':
        logPost($event['data']);

        if (isset($event['data']['repost_of']))
        {
          logPost($event['data']['repost_of']);
          logRepost($event['data']['repost_of']);
        }

        break;
      case 'star':
        logPost($event['data']['post']);
        logStar($event['data']['post']);
        break;
      default:
        return;
        break;
    }
  }
}

function logPost($post)
{
  global $db;

  if (!isset($post['text']))
  {
    // DW: Skip this, no post
    return;
  }

  if (isset($post['is_deleted']))
  {
    // DW: Skip this, deleted
    return;
  }

  // DW: Insert source
  $sourceIdQuery = $db->query("select `id` from `sources` where `client_id` = '" . $post['source']['client_id'] . "';");
  $sourceIdResult = $sourceIdQuery->fetch_assoc();
  if (!$sourceIdResult)
  {
    $db->query(sprintf("insert into `sources` (`client_id`, `name`, `create_date`) values ('%s', '%s', '%s');",
      $post['source']['client_id'], // DW: source id
      $post['source']['name'], // DW: source id
      $post['created_at']  // DW: create date
    ));

    $sourceIdQuery = $db->query("select `id` from `sources` where `client_id` = '" . $post['source']['client_id'] . "';");
    $sourceIdResult = $sourceIdQuery->fetch_assoc();
  }

  // DW: Insert post
  $db->query(sprintf("insert into `posts` (`id`, `user_id`, `source_id`, `message`, `length`, `stars`, `replys`, `reposts`, `create_date`) values ('%d', '%d', '%d', '%s', '%d', '%d', '%d', '0', '%s');",
    $post['id'], // DW: post id
    $post['user']['id'], // DW: user id
    $sourceIdResult['id'], // DW: source id
    $post['text'], // DW: message
    strlen($post['text']), // DW: length
    $post['num_stars'], // DW: stars
    $post['num_replies'], // DW: replys
    $post['created_at']  // DW: create date
  ));

  if (isset($post['reply_to']))
  {
    logReply($post['reply_to']);
  }

  // DW: Insert user
  $userIdQuery = $db->query("select `id` from `users` where `id` = '" . $post['user']['id'] . "';");
  $userIdResult = $userIdQuery->fetch_assoc();
  if (!$userIdResult)
  {
    $db->query(sprintf("insert into `users` (`id`, `name`, `create_date`) values ('%d', '%s', '%s');",
      $post['user']['id'], // DW: user id
      $post['user']['username'], // DW: username
      $post['created_at']  // DW: create date
    ));
  }
  else
  {
    // DW: Temp to fix an earlier bug
    echo sprintf("Fixing user id: %d -> %s\r\n", $post['user']['id'], $post['user']['username']);
    $db->query(sprintf("update `users` set `name` = '%s' where `id` = '%d';",
      $post['user']['username'], // DW: username
      $post['user']['id'] // DW: user id
    ));
  }

  // DW: Add connections for each mention
  foreach ($post['entities']['mentions'] as $mention)
  {
    $userIdQuery = $db->query("select `id` from `users` where `id` = '" . $mention['id'] . "';");
    $userIdResult = $userIdQuery->fetch_assoc();
    if (!$userIdResult)
    {
      $db->query(sprintf("insert into `users` (`id`, `name`, `create_date`) values ('%d', '%s', '%s');",
        $mention['id'], // DW: user id
        $mention['name'], // DW: username
        $post['created_at']  // DW: create date
      ));
    }

    $db->query(sprintf("insert into `post_mentions` (`post_id`, `mention_id`) values ('%d', '%d');",
      $post['id'], // DW: post id
      $post['user']['id'] // DW: user id
    ));
  }

  // DW: Add connections for each hashtag
  foreach ($post['entities']['hashtags'] as $hashtag)
  {
    // DW: check for existing hash tag
    $hashtagIdQuery = $db->query("select `id` from `hashtags` where `hashtag` = '" . $hashtag['name'] . "';");
    $hashtagIdResult = $hashtagIdQuery->fetch_assoc();
    if (!$hashtagIdResult)
    {
      // DW: add the hashtag
      $db->query(sprintf("insert into `hashtags` (`hashtag`, `create_date`) values ('%s', '%s');",
        $hashtag['name'], // DW: hashtag
        $post['created_at']  // DW: create date
      ));
    }

    // DW: add the hashtag/post connection
    $hashtagIdQuery = $db->query("select `id` from `hashtags` where `hashtag` = '" . $hashtag['name'] . "';");
    $hashtagIdResult = $hashtagIdQuery->fetch_assoc();
    if ($hashtagIdResult)
    {
      $db->query(sprintf("insert into `post_hashtags` (`post_id`, `hashtag_id`) values ('%d', '%d');",
        $post['id'], // DW: post id
        $hashtagIdResult['id'] // DW: user id
      ));
    }
  }
}

function logStar($post)
{
  global $db;

  $db->query(sprintf("update `posts` set `stars` = `stars` + 1 where `id` = '%s';",
    $post['id']
  ));

  echo sprintf("Starred post: %s\r\n", $post['id']);
}

function logRepost($post)
{
  global $db;

  if (!isset($post['text']))
  {
    echo "repost: " . print_r($post);
    // DW: Skip this, no post
    return;
  }

  $db->query(sprintf("update `posts` set `reposts` = `reposts` + 1 where `id` = '%s';",
    $post['id']
  ));

  echo sprintf("Reposted post: %s\r\n", $post['id']);
}

function logReply($postId)
{
  global $db;

  $replyIdQuery = $db->query("select `id` from `posts` where `id` = '" . $postId . "';");
  $replyIdResult = $replyIdQuery->fetch_assoc();
  if ($replyIdResult)
  {
    $db->query(sprintf("update `posts` set `replys` = `replys` + 1 where `id` = '%s';",
      $postId
    ));

    echo sprintf("Reply to post: %s\r\n", $postId);
  }
}

// register that function as the stream handler
$adn->registerStreamFunction('handleEvent');

// open the stream for reading
$adn->openStream($stream['endpoint']);

// now we want to process the stream. We have two options. If all we're doing
// in this script is processing the stream, we can just call:
// $app->processStreamForever();
// otherwise you can create a loop, and call $app->processStream($milliseconds)
// intermittently, like:
while (true)
{
    // now we're going to process the stream for awhile
    $adn->processStream(10 * 1000000);
}

echo "\n";
