<?php
/**
 * DCSSettings.php
 *
 * Created by dave
 * Date: 2013-03-07
 *
 */

require_once 'AppDotNetPHP/AppDotNet.php';
require_once 'AppDotNetPHP/EZAppDotNet.php';

date_default_timezone_set('America/Toronto');

class DCSSettings
{
  public $clientId = 'x';
  public $clientSecret = 'x';

  // this must be one of the URLs defined in your App.net application settings
  public $callbackUri = 'http://xxx.x.xxx/callback/';

  // An array of permissions you're requesting from the user.
  // As a general rule you should only request permissions you need for your app.
  // By default all permissions are commented out, meaning you'll have access
  // to their basic profile only. Uncomment the ones you need.
  public $scopes = array (
    // 'basic', // See basic user info (default, may be given if not specified)
    // 'stream', // Read the user's personalized stream
    // 'email', // Access the user's email address
    // 'write_post', // Post on behalf of the user
    // 'follow', // Follow and unfollow other users
    // 'public_messages', // Send and receive public messages as this user
    // 'messages', // Send and receive public and private messages as this user
    // 'update_profile', // Update a user’s name, images, and other profile information
    // 'export', // Export all user data (shows a warning)
  );

  public $dbHost = 'localhost';
  public $dbName = 'appnetstats';
  public $dbUser = 'appnetstats';
  public $dbPass = 'x';

  public $demoFile = '../docroot/demo.json';
}
