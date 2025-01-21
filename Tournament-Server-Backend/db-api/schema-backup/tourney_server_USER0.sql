-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: tourney-server-dev.crw7j7mduhsz.af-south-1.rds.amazonaws.com    Database: tourney_server
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `USER`
--

DROP TABLE IF EXISTS `USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER` (
  `USER_ID` varchar(128) NOT NULL COMMENT 'The user''s unique UUID generated each time a new user is registered',
  `USER_FNAME` varchar(45) NOT NULL,
  `USER_LNAME` varchar(45) NOT NULL,
  `USERNAME` varchar(45) NOT NULL COMMENT 'The user''s username',
  `USER_EMAIL` varchar(45) NOT NULL,
  `USER_PASSWD` varchar(256) NOT NULL COMMENT 'The user''s password, stored as an SHA-256 hash',
  `USER_IS_ADMIN` tinyint NOT NULL DEFAULT '0' COMMENT 'Whether the user is a player or administrator',
  `USER_NOTIFICATIONS` tinyint NOT NULL DEFAULT '0' COMMENT 'Whether the user would like to recieve notifications',
  `USER_DP` varchar(100) NOT NULL DEFAULT 'https://i.imgur.com/CjnIMqJ.png' COMMENT 'User''s display picture URL',
  `USER_DESCRIPTION` varchar(100) NOT NULL DEFAULT 'I am a user',
  PRIMARY KEY (`USER_ID`),
  UNIQUE KEY `USER_ID_UNIQUE` (`USER_ID`),
  UNIQUE KEY `USERNAME_UNIQUE` (`USERNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER`
--

LOCK TABLES `USER` WRITE;
/*!40000 ALTER TABLE `USER` DISABLE KEYS */;
INSERT INTO `USER` VALUES ('0fbe7dd3-20b4-400a-ad28-53d86dd36cd2','Michael','Le Forestier','MikeyMike','2322970@students.wits.ac.za','hockey',0,0,'https://i.imgur.com/rrJxe8N.jpg','I am a user'),('23d32596-6872-4173-b79e-94d7afb45d81','Katlego','Kungoane','KatTheGod','2320690@students.wits.ac.za','people998',0,0,'https://i.imgur.com/UxJtp4b.jpg','I take second, because I inspire and never take credit.'),('4a0c861e-0e64-11ed-8a34-0ea680fee648','Vita','Schamberger','iusto457','Kole.Grady17@gmail.com','69hu8dzdh6',1,1,'http://lorempixel.com/640/480/abstract','tenetur veniam atque laboriosam autem earum dolorum excepturi hic consequuntur'),('68c9c890-2c4d-4fde-ae53-ce20c9151f49','Gregory','Cowan','lordGregorious','2395453@students.wits.ac.za','CAM is my ham',0,0,'https://i.imgur.com/CjnIMqJ.png','I am a user'),('820a3ff2-55cb-4e6d-9763-94f762e9c80d','Musawenkosi','Gumpu','Moose918','2326254@students.wits.ac.za','musa',0,0,'https://i.imgur.com/CjnIMqJ.png','I am a user'),('b79d39e9-9f8d-4534-b842-564b39e7cbb7','Verushan','Naidoo','Elementrix','2374896@students.wits.ac.za','Keanu',0,0,'https://i.imgur.com/CjnIMqJ.png','I am a user'),('e0e35f91-5b72-487d-bad9-54221e08b22f','Mulanga','Sibeli','Lover Boy','2126182@students.wits.ac.za','mulanga',0,0,'https://i.imgur.com/CjnIMqJ.png','I am a user'),('e11036e6-dfa4-419d-90a4-4374ae609d4c','Kian','Reddy','Kixn','2307935@students.wits.ac.za','react',0,0,'https://i.imgur.com/CjnIMqJ.png','I am a user'),('ef368c5d-b01e-48c6-81bd-33e15f27bb2f','Thabo','Mohapi','Zizi','2150723@students.wits.ac.za','Papa Drake',0,0,'https://i.imgur.com/CjnIMqJ.png','I am a user');
/*!40000 ALTER TABLE `USER` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-07-28 16:09:40
