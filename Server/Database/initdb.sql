-- appnetstats database
SET NAMES utf8;
SET character_set_client = utf8;

-- Dev
create database if not exists appnetstats;
grant all privileges on appnetstats.* to appnetstats@'%' identified by 'x';
grant all privileges on appnetstats.* to appnetstats@'localhost' identified by 'x';
