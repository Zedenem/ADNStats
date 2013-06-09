-- --------------------------------------------------------------------------
-- users
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users`
(
  `id` bigint(30) unsigned NOT NULL auto_increment primary key,
  `name` varchar(255) default '',
  `create_date` datetime NOT NULL,

  INDEX `index_name` ( `name` ),
  INDEX `index_create_date` ( `create_date` )
) engine=MyISAM character set utf8;
-- --------------------------------------------------------------------------

