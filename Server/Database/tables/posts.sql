-- --------------------------------------------------------------------------
-- posts
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `posts`
(
  `id` bigint(30) unsigned NOT NULL auto_increment primary key,
  `user_id` bigint(30) unsigned NOT NULL default 0,
  `source_id` bigint(30) unsigned NOT NULL default 0,
  `message` varchar(255) default '',
  `length` tinyint(3) unsigned NOT NULL default 0,
  `stars` bigint(30) unsigned NOT NULL default 0,
  `replys` bigint(30) unsigned NOT NULL default 0,
  `reposts` bigint(30) unsigned NOT NULL default 0,
  `create_date` datetime NOT NULL,

  INDEX `index_user_id` ( `user_id` ),
  INDEX `index_create_date` ( `create_date` )
) engine=MyISAM character set utf8;
-- --------------------------------------------------------------------------

