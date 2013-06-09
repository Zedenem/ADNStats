-- --------------------------------------------------------------------------
-- post_hashtags
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `post_hashtags`
(
  `id` bigint(30) unsigned NOT NULL auto_increment primary key,
  `post_id` bigint(30) unsigned NOT NULL default 0,
  `hashtag_id` bigint(30) unsigned NOT NULL default 0,

  INDEX `index_post_id` ( `post_id` ),
  INDEX `index_hashtag_id` ( `hashtag_id` ),
  INDEX `index_post_hashtag_id` ( `post_id`, `hashtag_id` )
) engine=MyISAM character set utf8;
-- --------------------------------------------------------------------------

