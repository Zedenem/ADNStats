-- --------------------------------------------------------------------------
-- settings
-- --------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `settings`
(
  `id` bigint(30) unsigned NOT NULL auto_increment primary key,
  `key` varchar(255) default '',
  `value` varchar(255) default '',

  INDEX `index_key` ( `key` ),
  INDEX `index_value` ( `value` )
) engine=MyISAM character set utf8;
-- --------------------------------------------------------------------------

