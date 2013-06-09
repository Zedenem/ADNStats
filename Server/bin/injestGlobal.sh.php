#!/usr/bin/php -q -d include_path=.:..:../Libraries:/usr/share/php:
<?php

require_once 'DCSSettings.php';

$settings = new DCSSettings();

$adn = new AppDotNet($settings->clientId, $settings->clientSecret);

// You need an app token to consume the stream, get the token returned by App.net
// (this also sets the token)
$token = $adn->getAppAccessToken();
print 'App Token: ' . $token . "\n\n";

// getting a 400 error
// 1. first check to make sure you set your app_clientId & app_clientSecret correctly
// if that doesn't fix it, try this
// 2. It's possible you have hit your stream limit (5 stream per app)
// uncomment this to clear all the streams you've previously created
// $adn->deleteAllStreams();

// create a stream
// if you already have a stream you can skip this step
// this stream is going to consume posts and stars (but not follows)
// $stream = $adn->createStream(array('post', 'star', 'user_follow'));

// you might want to save $stream['endpoint'] or $stream['id'] for later so
// you don't have to re-create the stream
// print "stream id [" . $stream['id'] . "]\n";
$stream = $adn->getStream(1295);


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
  global $counters;

  $json = json_encode($event['data']);

  print $json . "\n\n";

  $counters[$event['meta']['type']]++;

  if (isset($event['meta']['is_deleted']))
  {
    switch ($event['meta']['type'])
    {
        case 'post':
            print $event['meta']['is_deleted'] ? 'p' : 'P';
            break;
        case 'star':
            print $event['meta']['is_deleted'] ? '_' : '*';
            break;
        case 'user_follow':
            print $event['meta']['is_deleted'] ? 'f' : 'F';
            break;
        case 'stream_marker':
            print $event['meta']['is_deleted'] ? '/' : '=';
            break;
        case 'message':
            print $event['meta']['is_deleted'] ? 'm' : 'M';
            break;
        case 'channel':
            print $event['meta']['is_deleted'] ? 'c' : 'C';
            break;
        case 'channel_subscription':
            print $event['meta']['is_deleted'] ? 'f' : 'F';
            break;
        default:
            print "Unknown type [" . $event['meta']['type'] . "]\n";
            break;
    }
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
    $counters = array('post' => 0, 'star' => 0, 'user_follow' => 0, 'stream_marker' => 0, 'message' => 0, 'channel' => 0, 'channel_subscription' => 0);

    // now we're going to process the stream for awhile
    $adn->processStream(10 * 1000000);

    echo "\n";

    // show some stats
    echo date('H:i')." [", $counters['post'], "]posts [", $counters['star'], "]stars [", $counters['user_follow'], "]follow [", $counters['stream_marker'], "]mrkrs [", $counters['message'], "]msgs /min\n";
    // then do something else...
}

