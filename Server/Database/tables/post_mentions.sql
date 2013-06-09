-- --------------------------------------------------------------------------
-- post_mentions
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `post_mentions`
(
  `id` bigint(30) unsigned NOT NULL auto_increment primary key,
  `post_id` bigint(30) unsigned NOT NULL default 0,
  `mention_id` bigint(30) unsigned NOT NULL default 0,

  INDEX `index_post_id` ( `post_id` ),
  INDEX `index_mention_id` ( `mention_id` ),
  INDEX `index_post_mention_id` ( `post_id`, `mention_id` )
) engine=MyISAM character set utf8;
-- --------------------------------------------------------------------------

