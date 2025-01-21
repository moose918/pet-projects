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
-- Table structure for table `TOURNAMENT`
--

DROP TABLE IF EXISTS `TOURNAMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TOURNAMENT` (
  `TOURNAMENT_ID` varchar(45) NOT NULL COMMENT 'The UUID of the tournament',
  `TOURNAMENT_NAME` varchar(100) NOT NULL,
  `GAME_ID` varchar(45) NOT NULL COMMENT 'The UUID of the game this tournament falls under',
  `TOURNAMENT_DP` varchar(100) NOT NULL DEFAULT 'https://i.imgur.com/1RiwbPp.png',
  `TOURNAMENT_IS_OPEN` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`TOURNAMENT_ID`),
  UNIQUE KEY `TOURNAMENT_ID_UNIQUE` (`TOURNAMENT_ID`),
  UNIQUE KEY `TOURNAMENT_NAME_UNIQUE` (`TOURNAMENT_NAME`),
  KEY `GAME_ID_idx` (`GAME_ID`),
  CONSTRAINT `GAME_ID_TOURNAMENT` FOREIGN KEY (`GAME_ID`) REFERENCES `GAME` (`GAME_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TOURNAMENT`
--

LOCK TABLES `TOURNAMENT` WRITE;
/*!40000 ALTER TABLE `TOURNAMENT` DISABLE KEYS */;
INSERT INTO `TOURNAMENT` VALUES ('01934c61-c6f6-11ec-a02e-0ab3cd6d5505','Rk-Ppr-Scrs-Lzrd-Spk Tourney','b772386d-c6f5-11ec-a02e-0ab3cd6d5505','https://i.imgur.com/U54ROen.png',1),('14c26fd7-0e79-11ed-8a34-0ea680fee648','sit-fuga-et','b772386d-c6f5-11ec-a02e-0ab3cd6d5505','http://lorempixel.com/640/480/abstract',0),('219904e0-0cd1-11ed-8a34-0ea680fee648','voluptatem-recusandae-vel','b772386d-c6f5-11ec-a02e-0ab3cd6d5505','http://lorempixel.com/640/480/abstract',0),('22531f29-cd83-11ec-8a34-0ea680fee648','Greg\'s Tic-Tac-Toe Tourney','886edf86-c6f5-11ec-a02e-0ab3cd6d5505','https://i.imgur.com/Smh9LAR.jpg',1),('ae611393-0c5f-11ed-8a34-0ea680fee648','rerum-minima-dicta','b772386d-c6f5-11ec-a02e-0ab3cd6d5505','http://lorempixel.com/640/480/abstract',0),('e517ddaa-0e7b-11ed-8a34-0ea680fee648','aspernatur-hic-rerum','b772386d-c6f5-11ec-a02e-0ab3cd6d5505','http://lorempixel.com/640/480/abstract',1),('e9e26b2a-c6f5-11ec-a02e-0ab3cd6d5505','Tic-Tac-Toe-Tourney','886edf86-c6f5-11ec-a02e-0ab3cd6d5505','https://i.imgur.com/weQItUY.jpg',1);
/*!40000 ALTER TABLE `TOURNAMENT` ENABLE KEYS */;
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

-- Dump completed on 2022-07-28 16:09:18
