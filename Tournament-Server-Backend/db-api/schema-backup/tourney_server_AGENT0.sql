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
-- Table structure for table `AGENT`
--

DROP TABLE IF EXISTS `AGENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AGENT` (
  `AGENT_ID` varchar(45) NOT NULL COMMENT 'UUID of the player''s agent',
  `AGENT_NAME` varchar(100) NOT NULL,
  `USER_ID` varchar(45) NOT NULL COMMENT 'The player''s UUID',
  `ADDRESS_ID` varchar(45) NOT NULL COMMENT 'The agent''s address UUID',
  `AGENT_STATUS` tinyint(1) NOT NULL DEFAULT '-1' COMMENT 'Indicates the agent''s availability -1:Offline 0:Inactive 1:Active',
  PRIMARY KEY (`AGENT_ID`),
  UNIQUE KEY `AGENT_ID_UNIQUE` (`AGENT_ID`),
  UNIQUE KEY `ADDRESS_ID_UNIQUE` (`ADDRESS_ID`),
  KEY `ADDRESS_ID_idx` (`ADDRESS_ID`),
  KEY `USER_ID_idx` (`USER_ID`),
  CONSTRAINT `ADDRESS_ID_AGENT` FOREIGN KEY (`ADDRESS_ID`) REFERENCES `ADDRESS` (`ADDRESS_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `USER_ID_AGENT` FOREIGN KEY (`USER_ID`) REFERENCES `USER` (`USER_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AGENT`
--

LOCK TABLES `AGENT` WRITE;
/*!40000 ALTER TABLE `AGENT` DISABLE KEYS */;
INSERT INTO `AGENT` VALUES ('0e852e78-207e-4bc8-bb9d-215ab10cc385','','ef368c5d-b01e-48c6-81bd-33e15f27bb2f','de075ab8-2c17-49e9-81e9-fa41063dc5fb',-1),('173afbb4-f4d0-446f-ac79-89695ea643bc','','ef368c5d-b01e-48c6-81bd-33e15f27bb2f','82239217-454d-4ef6-bc66-12a99d494ed7',-1),('1aea2e2e-be8a-4aaa-8c43-5fe4bb60467e','','e0e35f91-5b72-487d-bad9-54221e08b22f','4c0e9f47-c474-4f46-8563-60fb48b88b6c',-1),('26ef3200-98dd-469c-985e-3c0811c495e4','','68c9c890-2c4d-4fde-ae53-ce20c9151f49','271468da-da2c-4aa0-add8-5263e7e129cd',-1),('37729ba7-b6ec-4d41-aa04-e8d9a4bc19e6','','23d32596-6872-4173-b79e-94d7afb45d81','20d358ff-e9a6-4a74-8e91-7242b4f1e3d7',-1),('46b0666c-e3e8-11ec-8a34-0ea680fee648','Ian Nepomniatchi','68c9c890-2c4d-4fde-ae53-ce20c9151f49','467f1657-e3e8-11ec-8a34-0ea680fee648',-1),('6cb7eb05-7012-44a5-945d-ac10a6782999','','b79d39e9-9f8d-4534-b842-564b39e7cbb7','be074fd6-9b33-45b9-b6ec-18c6505becf0',-1),('6d449938-0e75-11ed-8a34-0ea680fee648','Vita oTHER Agent','4a0c861e-0e64-11ed-8a34-0ea680fee648','6d361982-0e75-11ed-8a34-0ea680fee648',-1),('7ddc7016-9a9a-4e06-9102-3d6b96da2f1b','','e11036e6-dfa4-419d-90a4-4374ae609d4c','db94ee3e-3104-4ce3-b710-bd3b0bc48c9d',-1),('7f2cd061-e4ef-11ec-8a34-0ea680fee648','mooseFin','68c9c890-2c4d-4fde-ae53-ce20c9151f49','7efb931f-e4ef-11ec-8a34-0ea680fee648',-1),('84c51800-e3e8-11ec-8a34-0ea680fee648','KSI','68c9c890-2c4d-4fde-ae53-ce20c9151f49','8494c24b-e3e8-11ec-8a34-0ea680fee648',-1),('8a2adda8-e091-11ec-8a34-0ea680fee648','mooseFin','820a3ff2-55cb-4e6d-9763-94f762e9c80d','89f98699-e091-11ec-8a34-0ea680fee648',-1),('a687bd27-a9de-4385-aee1-e2d23a405446','','820a3ff2-55cb-4e6d-9763-94f762e9c80d','28aa20cd-a1c6-49ed-a951-69efa31ddb84',-1),('ab94e34d-d935-11ec-8a34-0ea680fee648','Magnus Carlsen','68c9c890-2c4d-4fde-ae53-ce20c9151f49','ab626528-d935-11ec-8a34-0ea680fee648',-1),('b724d13a-32e0-400b-a6ac-9b499a41c511','','e11036e6-dfa4-419d-90a4-4374ae609d4c','6c57bad6-4b83-42b1-88a2-3bca282e1998',-1),('c4139f3e-da0e-11ec-8a34-0ea680fee648','Stalin','e11036e6-dfa4-419d-90a4-4374ae609d4c','c3e3d96d-da0e-11ec-8a34-0ea680fee648',-1),('d1e7c053-ce94-4bc0-9a7c-e7949de6da53','','820a3ff2-55cb-4e6d-9763-94f762e9c80d','b4820deb-84d0-4990-b984-01e0cbf69b92',-1),('d1ef799e-689f-4d98-8358-0f42c49fb3b1','','23d32596-6872-4173-b79e-94d7afb45d81','a81207ab-df59-4847-a2b1-dc6eca7a6500',-1),('e2474139-8d71-45f4-a7c8-5a69329a1ebe','WHOOOOOOOOO','68c9c890-2c4d-4fde-ae53-ce20c9151f49','b2e6418d-6b45-453b-afc2-6c5e833e79e4',-1),('e3799ca9-1778-4171-93af-b91a93a01ec3','','b79d39e9-9f8d-4534-b842-564b39e7cbb7','36b8b5a4-bcb5-434f-9027-59e82299d5e1',-1),('f64da681-86c9-4b68-a266-7ae4b8668449','','0fbe7dd3-20b4-400a-ad28-53d86dd36cd2','a4dd3bcd-ca94-4aff-a0b1-241a9f487e58',-1),('fb7edb19-1d5f-4f58-a07e-33e42f3a7310','','e0e35f91-5b72-487d-bad9-54221e08b22f','beb170c7-27a5-4810-8d6f-7bdb687e6b5b',-1),('fdf8799a-492d-43d5-a30e-77edadd0d8b1','','0fbe7dd3-20b4-400a-ad28-53d86dd36cd2','1e7f693c-32c2-4b01-91d0-67a4d8741d2e',-1);
/*!40000 ALTER TABLE `AGENT` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`admin`@`%`*/ /*!50003 TRIGGER `AGENT_BEFORE_DELETE` BEFORE DELETE ON `AGENT` FOR EACH ROW BEGIN
	DELETE FROM AGENT_TOURNAMENT AS AGT
    WHERE AGT.AGENT_ID = OLD.AGENT_ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`admin`@`%`*/ /*!50003 TRIGGER `AGENT_AFTER_DELETE` AFTER DELETE ON `AGENT` FOR EACH ROW BEGIN
	DELETE FROM ADDRESS
    WHERE ADDRESS.ADDRESS_ID = OLD.ADDRESS_ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-07-28 16:09:06
