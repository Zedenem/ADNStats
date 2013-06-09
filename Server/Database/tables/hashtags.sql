-- --------------------------------------------------------------------------
-- hashtags
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `hashtags`
(
  `id` bigint(30) unsigned NOT NULL auto_increment primary key,
  `hashtag` varchar(255) default '',
  `create_date` datetime NOT NULL,

  INDEX `index_hashtag` ( `hashtag` ),
  INDEX `index_create_date` ( `create_date` )
) engine=MyISAM character set utf8;
-- --------------------------------------------------------------------------

