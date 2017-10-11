-- MySQL dump 10.10
--
-- Host: 10.154.40.51    Database: db_sanguo_stat
-- ------------------------------------------------------
-- Server version	5.0.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `table_alliance_stat`
--

DROP TABLE IF EXISTS `table_alliance_stat`;
CREATE TABLE `table_alliance_stat` (
  `date` char(10) NOT NULL,
  `alliance_count` int(11) default NULL,
  `average_member_count` int(11) default NULL,
  `average_owner_level` int(11) default NULL,
  `min_owner_level` int(11) default NULL,
  `average_member_level` int(11) default NULL,
  `all_member_count` int(11) default NULL,
  `all_user_count` int(11) default NULL,
  `attack_count_from_alliance` int(11) default NULL,
  `attack_count_all` int(11) default NULL,
  `max_point` int(11) default NULL,
  `DAUAlliance` int(11) default '0',
  `DAU` int(11) default '0',
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_feeds_stat`
--

DROP TABLE IF EXISTS `table_feeds_stat`;
CREATE TABLE `table_feeds_stat` (
  `date` char(10) NOT NULL default '',
  `feedid` int(11) NOT NULL default '0',
  `feed_count` int(11) default '0',
  `click_count` int(11) default '0',
  `title` varchar(1024) default '',
  PRIMARY KEY  (`date`,`feedid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_friend_num_stat`
--

DROP TABLE IF EXISTS `table_friend_num_stat`;
CREATE TABLE `table_friend_num_stat` (
  `date` char(10) NOT NULL,
  `user_count` int(11) default NULL,
  `average_count` float default NULL,
  `max_friend_number` int(11) default NULL,
  `Datas` varchar(1024) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_level_stat`
--

DROP TABLE IF EXISTS `table_level_stat`;
CREATE TABLE `table_level_stat` (
  `date` char(10) NOT NULL,
  `average_level` float default NULL,
  `Datas` varchar(1024) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_lose_distribute_stat`
--

DROP TABLE IF EXISTS `table_lose_distribute_stat`;
CREATE TABLE `table_lose_distribute_stat` (
  `date` char(10) NOT NULL,
  `all_lose_count` int(11) default NULL,
  `all_live_count` int(11) default NULL,
  `lose_level1` int(11) default NULL,
  `lose_level2` int(11) default NULL,
  `lose_level3` int(11) default NULL,
  `lose_level4` int(11) default NULL,
  `lose_level5` int(11) default NULL,
  `lose_level6_10` int(11) default NULL,
  `lose_level11_15` int(11) default NULL,
  `lose_level15_20` int(11) default NULL,
  `lose_level_other` int(11) default NULL,
  `live_level1` int(11) default NULL,
  `live_level2` int(11) default NULL,
  `live_level3` int(11) default NULL,
  `live_level4` int(11) default NULL,
  `live_level5` int(11) default NULL,
  `live_level6_10` int(11) default NULL,
  `live_level11_15` int(11) default NULL,
  `live_level15_20` int(11) default NULL,
  `live_other` int(11) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_monitor`
--

DROP TABLE IF EXISTS `table_monitor`;
CREATE TABLE `table_monitor` (
  `date` char(10) default NULL,
  `ip` char(16) default NULL,
  `type` char(16) default NULL,
  `content` varchar(256) default NULL,
  `updatetime` datetime default NULL,
  `iswarned` int(11) default '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_nature_distribute_stat`
--

DROP TABLE IF EXISTS `table_nature_distribute_stat`;
CREATE TABLE `table_nature_distribute_stat` (
  `date` char(10) NOT NULL,
  `all_rookie_count` int(11) default NULL,
  `average_level` float default NULL,
  `level1` int(11) default NULL,
  `level2` int(11) default NULL,
  `level3` int(11) default NULL,
  `level4` int(11) default NULL,
  `level5` int(11) default NULL,
  `level_other` int(11) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_nature_returning_stat`
--

DROP TABLE IF EXISTS `table_nature_returning_stat`;
CREATE TABLE `table_nature_returning_stat` (
  `date` char(10) NOT NULL,
  `all_rookie_count` int(11) default NULL,
  `d1` float default NULL,
  `d2` float default NULL,
  `d3` float default NULL,
  `d4` float default NULL,
  `d5` float default NULL,
  `d6` float default NULL,
  `d7` float default NULL,
  `d8` float default NULL,
  `d9` float default NULL,
  `d10` float default NULL,
  `d11` float default NULL,
  `d12` float default NULL,
  `d13` float default NULL,
  `d14` float default NULL,
  `week_return_rate` float default '0',
  `dweek_return_rate` float default '0',
  `month_return_rate` float default '0',
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_nature_returning_stat_new`
--

DROP TABLE IF EXISTS `table_nature_returning_stat_new`;
CREATE TABLE `table_nature_returning_stat_new` (
  `date` char(10) NOT NULL,
  `all_rookie_count` int(11) default NULL,
  `d1` float default NULL,
  `d2` float default NULL,
  `d3` float default NULL,
  `d4` float default NULL,
  `d5` float default NULL,
  `d6` float default NULL,
  `d7` float default NULL,
  `d8` float default NULL,
  `d9` float default NULL,
  `d10` float default NULL,
  `d11` float default NULL,
  `d12` float default NULL,
  `d13` float default NULL,
  `d14` float default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_online_time_stat`
--

DROP TABLE IF EXISTS `table_online_time_stat`;
CREATE TABLE `table_online_time_stat` (
  `date` char(10) NOT NULL,
  `login_uin` int(11) default NULL,
  `login_count` int(11) default NULL,
  `average_time` float default NULL,
  `Datas` varchar(1024) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_pay_returning_stat`
--

DROP TABLE IF EXISTS `table_pay_returning_stat`;
CREATE TABLE `table_pay_returning_stat` (
  `date` char(10) NOT NULL,
  `all_rookie_count` int(11) default NULL,
  `d1` float default NULL,
  `d2` float default NULL,
  `d3` float default NULL,
  `d4` float default NULL,
  `d5` float default NULL,
  `d6` float default NULL,
  `d7` float default NULL,
  `d8` float default NULL,
  `d9` float default NULL,
  `d10` float default NULL,
  `d11` float default NULL,
  `d12` float default NULL,
  `d13` float default NULL,
  `d14` float default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_pay_tools_stat`
--

DROP TABLE IF EXISTS `table_pay_tools_stat`;
CREATE TABLE `table_pay_tools_stat` (
  `date` char(10) NOT NULL,
  `user_count` int(11) default NULL,
  `all_money` int(11) default NULL,
  `tool_datas` varchar(1024) default NULL,
  `count_datas` varchar(1024) default NULL,
  `money_datas` varchar(1024) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_returning_stat`
--

DROP TABLE IF EXISTS `table_returning_stat`;
CREATE TABLE `table_returning_stat` (
  `date` char(10) NOT NULL,
  `all_rookie_count` int(11) default NULL,
  `d1` float default NULL,
  `d2` float default NULL,
  `d3` float default NULL,
  `d4` float default NULL,
  `d5` float default NULL,
  `d6` float default NULL,
  `d7` float default NULL,
  `d8` float default NULL,
  `d9` float default NULL,
  `d10` float default NULL,
  `d11` float default NULL,
  `d12` float default NULL,
  `d13` float default NULL,
  `d14` float default NULL,
  `week_return_rate` float default '0',
  `dweek_return_rate` float default '0',
  `month_return_rate` float default '0',
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_returning_stat_new`
--

DROP TABLE IF EXISTS `table_returning_stat_new`;
CREATE TABLE `table_returning_stat_new` (
  `date` char(10) NOT NULL,
  `all_rookie_count` int(11) default NULL,
  `d1` float default NULL,
  `d2` float default NULL,
  `d3` float default NULL,
  `d4` float default NULL,
  `d5` float default NULL,
  `d6` float default NULL,
  `d7` float default NULL,
  `d8` float default NULL,
  `d9` float default NULL,
  `d10` float default NULL,
  `d11` float default NULL,
  `d12` float default NULL,
  `d13` float default NULL,
  `d14` float default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_rookie_distribute_stat`
--

DROP TABLE IF EXISTS `table_rookie_distribute_stat`;
CREATE TABLE `table_rookie_distribute_stat` (
  `date` char(10) NOT NULL,
  `all_rookie_count` int(11) default NULL,
  `average_level` float default NULL,
  `level1` int(11) default NULL,
  `level2` int(11) default NULL,
  `level3` int(11) default NULL,
  `level4` int(11) default NULL,
  `level5` int(11) default NULL,
  `level_other` int(11) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_tutorial_stage`
--

DROP TABLE IF EXISTS `table_tutorial_stage`;
CREATE TABLE `table_tutorial_stage` (
  `date` char(10) NOT NULL,
  `rookie_count` int(11) default NULL,
  `Datas` varchar(4007) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `table_user_day_data_stat`
--

DROP TABLE IF EXISTS `table_user_day_data_stat`;
CREATE TABLE `table_user_day_data_stat` (
  `date` char(10) NOT NULL,
  `AllUserCount` int(11) default NULL,
  `DWAU` int(11) default NULL,
  `DAU` int(11) default NULL,
  `MAU` int(11) default NULL,
  `DNU` int(11) default NULL,
  `DOU` int(11) default NULL,
  `DBU` int(11) default NULL,
  `DLU` int(11) default NULL,
  `DSU` int(11) default NULL,
  `DHU` int(11) default NULL,
  `DMU` int(11) default NULL,
  `DTU` int(11) default NULL,
  `DVU` int(11) default NULL,
  `DVC` int(11) default NULL,
  `DWU` int(11) default NULL,
  `DWC` int(11) default NULL,
  `DWUed` int(11) default NULL,
  `DWCed` int(11) default NULL,
  `DIU` int(11) default NULL,
  `DIUed` int(11) default NULL,
  `old_user_return` int(11) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

DROP TABLE IF EXISTS `table_cgi_stat`;
CREATE TABLE `table_cgi_stat` (
  `date` char(10) NOT NULL,
  `data` varchar(4007) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS`table_gunfu_stat`;
CREATE TABLE `table_gunfu_stat` (
  `date` char(10) NOT NULL,
  `g_credit` int(12) default NULL,
  `percent1` char(12) default NULL,
  `g_count` int(12) default NULL,
  `percent2` char(12) default NULL,
  PRIMARY KEY  (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
