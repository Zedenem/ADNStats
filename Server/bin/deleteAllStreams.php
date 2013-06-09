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
$adn->deleteAllStreams();

$db = new mysqli($settings->dbHost, $settings->dbUser, $settings->dbPass, $settings->dbName, 3306);
if ($db->connect_errno)
{
  echo "Failed to connect to MySQL: (" . $db->connect_errno . ") " . $db->connect_error;
  return;
}

$db->query("update `settings` set `value`='0' where `key` = 'streamId';");
$db->query("update `settings` set `value`='' where `key` = 'streamEndPoint';");
