-- --------------------------------------------------------------------------
-- sources
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sources`
(
  `id` bigint(30) unsigned NOT NULL auto_increment primary key,
  `client_id` varchar(255) default '',
  `name` varchar(255) default '',
  `create_date` datetime NOT NULL,

  INDEX `index_name` ( `name` ),
  INDEX `index_client_id` ( `client_id` ),
  INDEX `index_create_date` ( `create_date` )
) engine=MyISAM character set utf8;
-- --------------------------------------------------------------------------

