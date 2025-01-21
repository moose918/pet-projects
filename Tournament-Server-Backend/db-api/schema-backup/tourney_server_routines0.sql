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
-- Dumping events for database 'tourney_server'
--

--
-- Dumping routines for database 'tourney_server'
--
/*!50003 DROP PROCEDURE IF EXISTS `archive_agent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `archive_agent`(IN agentID VARCHAR(45))
BEGIN
	SET @aID = agentID;
    
    SET @moveStmt = 'INSERT INTO AGENT_TOURNAMENT_ARCHIVE (AGENT_ID, TOURNAMENT_ID, AGENT_ELO)
			SELECT AGENT_ID, TOURNAMENT_ID, AGENT_ELO
			FROM AGENT_TOURNAMENT
            WHERE AGENT_ID = ?';
    
    PREPARE stmt FROM @moveStmt;
    EXECUTE stmt USING @aID;
    DEALLOCATE PREPARE stmt;
    
    SET @moveStmt = 'INSERT INTO AGENT_RANKING_ARCHIVE (MATCH_LOG_ID, AGENT_ID, AGENT_NAME, USER_ID, USERNAME, RANKING)
			SELECT MATCH_LOG_ID, A.AGENT_ID, AGENT_NAME, U.USER_ID, USERNAME, RANKING
			FROM RANKING AS R 
				LEFT JOIN AGENT AS A ON R.AGENT_ID = A.AGENT_ID
                LEFT JOIN USER AS U ON A.USER_ID = U.USER_ID
            WHERE A.AGENT_ID = ?';
    
    PREPARE stmt FROM @moveStmt;
    EXECUTE stmt USING @aID;
    DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_existing_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `check_existing_user`(IN userName varchar(45))
    COMMENT 'Checks if a user exists given the username'
BEGIN

  SET @uName = userName;

  PREPARE existingUserCheck FROM 'SELECT COUNT(*) AS USER_COUNT FROM `USER` WHERE USERNAME = ?';

  EXECUTE existingUserCheck USING @uName;

  DEALLOCATE PREPARE existingUserCheck;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `close_tournament` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `close_tournament`(IN tournamentID VARCHAR(45))
BEGIN
	-- Close the tournament
	SET @tID = tournamentID;
    SET @toggleStmt = 'UPDATE TOURNAMENT
			SET TOURNAMENT_IS_OPEN = -1
            WHERE TOURNAMENT_ID = ?';
	
    PREPARE stmt FROM @toggleStmt;
    EXECUTE stmt USING @tID;
    DEALLOCATE PREPARE stmt;
    
    -- Move all agent bindings from closed tournament to the archive
    SET @toggleStmt = 'INSERT INTO AGENT_TOURNAMENT_ARCHIVE
	SELECT * 
	FROM AGENT_TOURNAMENT
	WHERE TOURNAMENT_ID = ?';
    
    PREPARE stmt FROM @toggleStmt;
    EXECUTE stmt USING @tID;
    DEALLOCATE PREPARE stmt;
    
    SET @toggleStmt = 'DELETE 
	FROM AGENT_TOURNAMENT
	WHERE TOURNAMENT_ID = ?';
    
    PREPARE stmt FROM @toggleStmt;
    EXECUTE stmt USING @tID;
    DEALLOCATE PREPARE stmt;
    
    -- Move all rankings of agents involved in the closed tournament
    SET @moveStmt = 'INSERT INTO AGENT_RANKING_ARCHIVE (MATCH_LOG_ID, AGENT_ID, AGENT_NAME, USER_ID, USERNAME, RANKING)
			SELECT DISTINCT R.MATCH_LOG_ID, A.AGENT_ID, A.AGENT_NAME, A.USER_ID, USERNAME, RANKING
			FROM RANKING AS R 
				LEFT JOIN AGENT AS A ON R.AGENT_ID = A.AGENT_ID
                LEFT JOIN MATCH_LOG AS ML ON R.MATCH_LOG_ID = ML.MATCH_LOG_ID
                LEFT JOIN `USER` AS U ON U.USER_ID = A.USER_ID
            WHERE ML.TOURNAMENT_ID = ?';

    PREPARE stmt FROM @moveStmt;
    EXECUTE stmt USING @tID;
    DEALLOCATE PREPARE stmt;
    
    SET @deleteStmt = 'DELETE FROM RANKING
		WHERE MATCH_LOG_ID IN 
			(SELECT MATCH_LOG_ID 
			FROM MATCH_LOG
			WHERE TOURNAMENT_ID = ?)';
            
	PREPARE stmt FROM @deleteStmt;
    EXECUTE stmt USING @tID;
    DEALLOCATE PREPARE stmt;
    
    -- Move all the match log data for all matches in the closed tournament
    SET @moveStmt = 'INSERT INTO MATCH_LOG_ARCHIVE (MATCH_LOG_ID, TOURNAMENT_ID, MATCH_LOG_DATA, MATCH_LOG_TIMESTAMP, MATCH_LOG_IN_PROGRESS)
		SELECT * 
        FROM MATCH_LOG
		WHERE TOURNAMENT_ID = ?';

    PREPARE stmt FROM @moveStmt;
    EXECUTE stmt USING @tID;
    DEALLOCATE PREPARE stmt;
    
    SET @deleteStmt = 'DELETE FROM MATCH_LOG
		WHERE TOURNAMENT_ID = ?';
            
	PREPARE stmt FROM @deleteStmt;
    EXECUTE stmt USING @tID;
    DEALLOCATE PREPARE stmt;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_agent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `delete_agent`(IN agentID VARCHAR(45))
    MODIFIES SQL DATA
    COMMENT 'Removes the given agent'
BEGIN
	SET @aID = agentID;
    SET @deleteStmt = 'DELETE FROM RANKING
			WHERE AGENT_ID = ?;';
	
    PREPARE stmt FROM @deleteStmt;
    EXECUTE stmt USING @aID;
    DEALLOCATE PREPARE stmt;
    
    SET @aID = agentID;
    SET @deleteStmt = 'DELETE FROM AGENT_TOURNAMENT
			WHERE AGENT_ID = ?;';
	
    PREPARE stmt FROM @deleteStmt;
    EXECUTE stmt USING @aID;
    DEALLOCATE PREPARE stmt;
    
    SET @aID = agentID;
    SET @deleteStmt = 'DELETE FROM AGENT
			WHERE AGENT_ID = ?;';
	
    PREPARE stmt FROM @deleteStmt;
    EXECUTE stmt USING @aID;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `end_live_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `end_live_game`(IN matchLogID VARCHAR(45), IN matchLogData LONGTEXT)
BEGIN
	SET @mID = matchLogID;
    SET @matchData = matchLogData;
    
    SET @updateStmt = 'UPDATE MATCH_LOG
		SET 
			MATCH_LOG_IN_PROGRESS  = 0,
			MATCH_LOG_DATA = ?
		WHERE MATCH_LOG_ID = ?';
    
    PREPARE stmt FROM @updateStmt;
    EXECUTE stmt USING @matchData, @mID;
    DEALLOCATE PREPARE stmt;
    
    CALL retrieve_row_entry("MATCH_LOG", "MATCH_LOG_ID", @mID);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `end_live_match` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `end_live_match`(IN matchLogID VARCHAR(45), IN matchLogData LONGTEXT)
    MODIFIES SQL DATA
    COMMENT 'Ends the live game'
BEGIN
	SET @mID = matchLogID;
    SET @matchData = matchLogData;
    
    SET @updateStmt = 'UPDATE MATCH_LOG
		SET 
			MATCH_LOG_IN_PROGRESS  = 0,
			MATCH_LOG_DATA = ?
		WHERE MATCH_LOG_ID = ?';
    
    PREPARE stmt FROM @updateStmt;
    EXECUTE stmt USING @matchData, @mID;
    DEALLOCATE PREPARE stmt;
    
    CALL retrieve_row_entry("MATCH_LOG", "MATCH_LOG_ID", @mID);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_agent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_agent`(IN agentID VARCHAR(45))
BEGIN
	SET @aID = agentID;
    SET @selectStmt = 'SELECT A.AGENT_ID, A.AGENT_NAME, AD.ADDRESS_IP, AD.ADDRESS_PORT, GAME_NAME, USERNAME, AGENT_ELO,  AGENT_STATUS, T.TOURNAMENT_ID, T.TOURNAMENT_NAME
		FROM USER AS U 
        INNER JOIN AGENT AS A ON (U.USER_ID = A.USER_ID) 
        LEFT JOIN AGENT_TOURNAMENT AS AGT ON (A.AGENT_ID = AGT.AGENT_ID)
		LEFT JOIN  TOURNAMENT AS T ON (AGT.TOURNAMENT_ID = T.TOURNAMENT_ID)
		LEFT JOIN MATCH_LOG AS M ON (T.TOURNAMENT_ID = M.TOURNAMENT_ID)
		LEFT JOIN GAME AS G ON (G.GAME_ID = T.GAME_ID)
        LEFT JOIN ADDRESS AS AD ON (A.ADDRESS_ID = AD.ADDRESS_ID)
		WHERE A.AGENT_ID = ?';
    
    PREPARE stmt FROM @selectStmt;
    EXECUTE stmt USING @aID;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_agents_from_tournament` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_agents_from_tournament`(IN tournamentID VARCHAR(45))
BEGIN
	SET @tID = tournamentID;
	SET @stmt =
	'SELECT U.USER_ID AS userID, U.USERNAME AS username, CONCAT(USER_FNAME, " ", USER_LNAME) AS fullName, AG.AGENT_ID AS agentID, ADDRESS_IP as ipAddress, ADDRESS_PORT AS portNum, AGENT_ELO AS agentELO
	FROM `AGENT` AS AG
		INNER JOIN `USER` AS U ON (AG.USER_ID = U.USER_ID)
        INNER JOIN `AGENT_TOURNAMENT` AGT ON (AG.AGENT_ID = AGT.AGENT_ID)
		INNER JOIN `ADDRESS` AS AD ON (AG.ADDRESS_ID = AD.ADDRESS_ID)
	WHERE AGT.TOURNAMENT_ID = ?
	ORDER BY agentELO DESC';
    
    PREPARE st FROM @stmt;
    EXECUTE st USING @tID;
    DEALLOCATE PREPARE st;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_agent_pair` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_agent_pair`(IN agentA VARCHAR(45), IN agentB VARCHAR(45), IN tournamentID VARCHAR(45))
BEGIN
	SET @aa = agentA;
    SET @ab = agentB;
    SET @tID = tournamentID;
    SET @getStmt = 'SELECT A.AGENT_ID, AGENT_NAME, U.USER_ID, U.USERNAME, AD.ADDRESS_IP, AD.ADDRESS_PORT, AGENT_ELO, A.AGENT_STATUS
			FROM AGENT AS A
				INNER JOIN AGENT_TOURNAMENT AS AGT ON (A.AGENT_ID = AGT.AGENT_ID)
				INNER JOIN `USER` AS U ON (A.USER_ID = U.USER_ID)
				INNER JOIN ADDRESS AS AD ON (A.ADDRESS_ID = AD.ADDRESS_ID)
			WHERE (A.AGENT_ID =  ? OR A.AGENT_ID = ?) AND  AGT.TOURNAMENT_ID = ?';
    
    PREPARE stmt FROM @getStmt;
    EXECUTE stmt USING @aa, @ab, @tID;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_agent_tournaments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_agent_tournaments`(IN agentID VARCHAR(45))
BEGIN
	SET @aID = agentID;
    SET @selectStmt = 'SELECT  T.TOURNAMENT_ID, T.TOURNAMENT_NAME, G.GAME_ID, G.GAME_NAME, AGENT_ELO
		FROM AGENT_TOURNAMENT AS AGT
			INNER JOIN TOURNAMENT AS T ON (AGT.TOURNAMENT_ID = T.TOURNAMENT_ID)
			INNER JOIN GAME AS G ON (T.GAME_ID = G.GAME_ID)
		WHERE AGT.AGENT_ID = ?';
    
    PREPARE stmt FROM @selectStmt;
    EXECUTE stmt USING @aID;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_live_matches` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_live_matches`(IN tournamentID VARCHAR(45))
BEGIN
	SET @tID = tournamentID;
    SET @getStmt = CONCAT('SELECT M.MATCH_LOG_ID, G.GAME_NAME, T.TOURNAMENT_ID, T.TOURNAMENT_NAME, M.MATCH_LOG_DATA, M.MATCH_LOG_TIMESTAMP, MATCH_LOG_IN_PROGRESS, U1.USERNAME AS U1_USERNAME, R1_AGENT_ID, R1_RANKING, U2.USERNAME AS U2_USERNAME, R2_AGENT_ID, R2_RANKING
		FROM `MATCH_LOG` AS M 
		LEFT JOIN 
			(SELECT R1.MATCH_LOG_ID, R1.AGENT_ID AS R1_AGENT_ID, R1.RANKING AS R1_RANKING, R2.AGENT_ID AS R2_AGENT_ID, R2.RANKING AS R2_RANKING FROM `RANKING` AS R1 INNER JOIN `RANKING` AS R2 ON (R1.MATCH_LOG_ID = R2.MATCH_LOG_ID AND R1.AGENT_ID != R2.AGENT_ID)
			GROUP BY R1.MATCH_LOG_ID) AS R ON (M.MATCH_LOG_ID = R.MATCH_LOG_ID)
		LEFT JOIN `AGENT` AS A1 ON (A1.AGENT_ID = R1_AGENT_ID)
		LEFT JOIN `AGENT` AS A2 ON (A2.AGENT_ID = R2_AGENT_ID)
		LEFT JOIN `USER` AS U1 ON (U1.USER_ID = A1.USER_ID)
		LEFT JOIN `USER` AS U2 ON (U2.USER_ID = A2.USER_ID)
		LEFT JOIN TOURNAMENT AS T ON (M.TOURNAMENT_ID = T.TOURNAMENT_ID)
		LEFT JOIN GAME AS G ON (G.GAME_ID = T.GAME_ID)
		WHERE MATCH_LOG_IN_PROGRESS = 1 AND T.TOURNAMENT_ID LIKE "%', @tID, '%"');
        
	PREPARE stmt FROM @getStmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_match_results` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_match_results`(IN whereCondition LONGTEXT)
BEGIN
SET @whereCon = whereCondition;
SET @stmt = CONCAT('
SELECT M.MATCH_LOG_ID, G.GAME_NAME, T.TOURNAMENT_ID, T.TOURNAMENT_NAME, M.MATCH_LOG_DATA, M.MATCH_LOG_TIMESTAMP, MATCH_LOG_IN_PROGRESS, U1.USERNAME AS U1_USERNAME, R1_AGENT_ID, R1_RANKING, U2.USERNAME AS U2_USERNAME, R2_AGENT_ID, R2_RANKING
FROM `MATCH_LOG` AS M 
LEFT JOIN 
	(SELECT R1.MATCH_LOG_ID, R1.AGENT_ID AS R1_AGENT_ID, R1.RANKING AS R1_RANKING, R2.AGENT_ID AS R2_AGENT_ID, R2.RANKING AS R2_RANKING FROM `RANKING` AS R1 INNER JOIN `RANKING` AS R2 ON (R1.MATCH_LOG_ID = R2.MATCH_LOG_ID AND R1.AGENT_ID != R2.AGENT_ID)
	GROUP BY R1.MATCH_LOG_ID) AS R ON (M.MATCH_LOG_ID = R.MATCH_LOG_ID)
LEFT JOIN `AGENT` AS A1 ON (A1.AGENT_ID = R1_AGENT_ID)
LEFT JOIN `AGENT` AS A2 ON (A2.AGENT_ID = R2_AGENT_ID)
LEFT JOIN `USER` AS U1 ON (U1.USER_ID = A1.USER_ID)
LEFT JOIN `USER` AS U2 ON (U2.USER_ID = A2.USER_ID)
LEFT JOIN TOURNAMENT AS T ON (M.TOURNAMENT_ID = T.TOURNAMENT_ID)
LEFT JOIN GAME AS G ON (G.GAME_ID = T.GAME_ID)
WHERE ', whereCondition);

PREPARE st FROM @stmt;
EXECUTE st;
DEALLOCATE PREPARE st;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_tournaments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_tournaments`(IN whereCondition LONGTEXT )
BEGIN
    SET @getStmt = CONCAT('SELECT TOURNAMENT_ID, TOURNAMENT_NAME, G.GAME_ID, GAME_NAME, TOURNAMENT_DP, TOURNAMENT_IS_OPEN
			FROM `TOURNAMENT` AS T
				INNER JOIN GAME AS G ON (T.GAME_ID = G.GAME_ID)
			WHERE ', whereCondition);
	
    PREPARE stmt FROM @getStmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_tournament_matches` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_tournament_matches`(IN tournamentID VARCHAR(100))
BEGIN
	SET @tID = tournamentID;
    SET @getStmt = 'SELECT * FROM MATCH_LOG WHERE TOURNAMENT_ID = ? ORDER BY MATCH_LOG_TIMESTAMP DESC';
    PREPARE stmt FROM @getStmt;
    EXECUTE stmt USING @tID;
    DEALLOCATE PREPARE stmt;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_user`(IN userName varchar(45), IN userEmail varchar(45), IN userPass text)
    COMMENT 'Checks if a user with the exact username or email and associated password exists, returning their dataset'
BEGIN

  SET @uName = userName;

  SET @uPass = userPass;

  SET @uEmail = userEmail;

   PREPARE loginCheck FROM 'SELECT * FROM `USER` WHERE  (USERNAME = ? AND USER_PASSWD = ?) OR (USER_EMAIL = ? AND USER_PASSWD = ?)';

   EXECUTE loginCheck USING @uName, @uPass, @uEmail, @uPass;

   DEALLOCATE PREPARE loginCheck;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_agents` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_user_agents`(IN userID VARCHAR(45))
BEGIN
	SET @uID = userID;
	SET @getAgents = 'SELECT A.AGENT_ID, A.AGENT_NAME, AD.ADDRESS_IP, AD.ADDRESS_PORT, GAME_NAME, USERNAME, AGENT_ELO,  AGENT_STATUS, T.TOURNAMENT_ID, T.TOURNAMENT_NAME
		FROM USER AS U 
        INNER JOIN AGENT AS A ON (U.USER_ID = A.USER_ID) 
        LEFT JOIN AGENT_TOURNAMENT AS AGT ON (A.AGENT_ID = AGT.AGENT_ID)
		LEFT JOIN  TOURNAMENT AS T ON (AGT.TOURNAMENT_ID = T.TOURNAMENT_ID)
		LEFT JOIN MATCH_LOG AS M ON (T.TOURNAMENT_ID = M.TOURNAMENT_ID)
		LEFT JOIN GAME AS G ON (G.GAME_ID = T.GAME_ID)
        LEFT JOIN ADDRESS AS AD ON (A.ADDRESS_ID = AD.ADDRESS_ID)
		WHERE U.USER_ID = ?
		ORDER BY M.MATCH_LOG_ID, AGENT_ELO DESC;';
	
    PREPARE stmt FROM @getAgents;
    EXECUTE stmt USING @uID;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_profile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `get_user_profile`(IN userID VARCHAR(45))
BEGIN
	SET @uID = userID;
	SET @stmt= 'SELECT U.USER_ID AS userID, USERNAME AS username, CONCAT(USER_FNAME, " ", USER_LNAME) AS fullName, GAME_NAME AS topGameName, TOURNAMENT_NAME AS topAgentTournament, topAgentID, topAgentELO, numAgents
		FROM `USER` AS U
			INNER JOIN (SELECT AA.AGENT_ID AS topAgentID, TOURNAMENT_ID, AGENT_NAME, USER_ID, ADDRESS_ID, MAX(AGENT_ELO) AS topAgentELO, COUNT(*) AS numAgents FROM `AGENT` AS AA INNER JOIN `AGENT_TOURNAMENT` AS AGT ON (AA.AGENT_ID = AGT.AGENT_ID) GROUP BY USER_ID) AS A ON (A.USER_ID = U.USER_ID) 
			INNER JOIN `TOURNAMENT` AS T ON (A.TOURNAMENT_ID = T.TOURNAMENT_ID)
			INNER JOIN `GAME` AS G ON (G.GAME_ID = T.GAME_ID)
		WHERE U.USER_ID = ?';

	PREPARE getProfile FROM @stmt;
	EXECUTE getProfile USING @uID;
	DEALLOCATE PREPARE getProfile;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_agent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `insert_agent`(IN agentName VARCHAR(100), IN userID VARCHAR(45), IN addressID VARCHAR(45))
    MODIFIES SQL DATA
    COMMENT 'Creates a new agent entry with the given userID, addressID'
BEGIN
	
  SET @uID = userID;
  SET @addID = addressID;
    
  IF (agentName = '') THEN SELECT USERNAME FROM `USER` WHERE USER_ID = userID INTO @aName;
  ELSE SET @aName = agentName;
  END IF;
  
  SET @insertAgent = 'INSERT INTO `AGENT`(AGENT_ID, AGENT_NAME, USER_ID, ADDRESS_ID)
  VALUES (UUID(), ?, ?, ?);';
  PREPARE stmt FROM @insertAgent;
  EXECUTE stmt USING @aName, @uID, @addID;
  DEALLOCATE PREPARE stmt;

  -- No need for prepared statements at this point
  SELECT AGENT_ID, AGENT_NAME, ADDRESS_IP, ADDRESS_PORT, AGENT_STATUS
  FROM AGENT AS AG INNER JOIN ADDRESS AS AD ON (AG.ADDRESS_ID = AD.ADDRESS_ID)
  WHERE AG.ADDRESS_ID = addressID;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_agent_address` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `insert_agent_address`(IN addressIP VARCHAR(15), IN portNum INT)
    MODIFIES SQL DATA
    COMMENT 'Creates a new address entry with the given addressIP and portNum'
BEGIN
  SET @ipAdd = addressIP;
  SET @pNum = portNum;
  SET @insertStmt = 'INSERT INTO `ADDRESS`(ADDRESS_ID, ADDRESS_IP, ADDRESS_PORT) VALUES (UUID(), ?, ?);';

  PREPARE stmt FROM @insertStmt;
  EXECUTE stmt USING @ipAdd, @pNum;
  DEALLOCATE PREPARE stmt;
  
  SET @retrieval = 'SELECT ADDRESS_ID FROM `ADDRESS` WHERE ADDRESS_IP = ? AND ADDRESS_PORT = ?';
  
  PREPARE stmt FROM @retrieval;
  EXECUTE stmt USING @ipAdd, @pNum;
  DEALLOCATE PREPARE stmt;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_agent_result` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `insert_agent_result`(IN matchLogID VARCHAR(45), IN agentID VARCHAR(45), IN ranking INT)
BEGIN
  SET @mlID = matchLogID;
  SET @aID = agentID;
  SET @ranking = ranking;
  
  INSERT INTO RANKING (MATCH_LOG_ID, AGENT_ID, RANKING)
  VALUES (@mlID, @aID, @ranking);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_agent_tournament` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `insert_agent_tournament`(IN agentID VARCHAR(45), IN tournamentID VARCHAR(45))
    MODIFIES SQL DATA
    COMMENT 'Binds the agent with the specified tournament'
BEGIN
	SET @aID = agentID;
    SET @tID = tournamentID;
    SET @insertStmt = 'INSERT INTO AGENT_TOURNAMENT (AGENT_ID, TOURNAMENT_ID)
		VALUES (?, ?);';
    
    PREPARE stmt FROM @insertStmt;
    EXECUTE stmt USING @aID, @tID;
    DEALLOCATE PREPARE stmt;
    
    SET @getStmt = 'SELECT * 
		FROM AGENT_TOURNAMENT
		WHERE AGENT_ID = ? AND TOURNAMENT_ID = ?';
        
	PREPARE stmt FROM @getStmt;
    EXECUTE stmt USING @aID, @tID;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `insert_game`(IN gameName VARCHAR(100), IN fileName VARCHAR(100), IN isSyncrhonus TINYINT(1))
    MODIFIES SQL DATA
    COMMENT 'Creates a new game entry with its gameName and associated path to the fileName'
BEGIN

  INSERT INTO `GAME`(GAME_ID, GAME_NAME, FILE_NAME, GAME_SYNCHRONUS)
  VALUES (UUID(), gameName, fileName, isSyncrhonus);

  CALL retrieve_row_entry("GAME", "GAME_NAME", gameName);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_match_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `insert_match_log`(IN tournamentID VARCHAR(45), IN matchLog LONGTEXT)
    MODIFIES SQL DATA
    COMMENT 'Inserts a past match'
BEGIN

  SET @matchLogTime = CURRENT_TIMESTAMP();
  SET @matchData = matchLog;
  
  INSERT INTO `MATCH_LOG`(MATCH_LOG_ID, TOURNAMENT_ID, MATCH_LOG_TIMESTAMP, MATCH_LOG_DATA)

  VALUES (UUID(), tournamentID, @matchLogTime, @matchData);

  CALL retrieve_row_entry("MATCH_LOG", "MATCH_LOG_TIMESTAMP", @matchLogTime);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_ranking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `insert_ranking`(IN matchLogID VARCHAR(45), IN agentID VARCHAR(45), IN ranking INT)
    MODIFIES SQL DATA
    COMMENT 'Creates a new ranking to a particular match for an agent'
BEGIN

  INSERT INTO `RANKING`(MATCH_LOG_ID, AGENT_ID, `RANK`)

  VALUES (matchLogID, agentID, ranking);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_tournament` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `insert_tournament`(IN tournamentName VARCHAR(100), IN gameID VARCHAR(45), IN tournamentDP VARCHAR(100))
    MODIFIES SQL DATA
    COMMENT 'Creates a new tournament entry with the associated tournament name and the gameID it belongs to'
BEGIN

  INSERT INTO `TOURNAMENT`(TOURNAMENT_ID, TOURNAMENT_NAME, GAME_ID, TOURNAMENT_DP)

  VALUES (UUID(), tournamentName, gameID, tournamentDP);

  CALL retrieve_row_entry("TOURNAMENT", "TOURNAMENT_NAME", tournamentName);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `insert_user`(IN fName VARCHAR(45), IN lName VARCHAR(45), IN username varchar(45), IN userEmail VARCHAR(45), IN userPass VARCHAR(100), IN isAdmin TINYINT, IN wantsNotifications tinyint, IN userDP VARCHAR(100), IN userDescr VARCHAR(100))
    MODIFIES SQL DATA
    COMMENT 'Creates a new user with its associated values'
BEGIN

  INSERT INTO `USER`(USER_ID, USER_FNAME, USER_LNAME, USERNAME, USER_EMAIL, USER_PASSWD, USER_IS_ADMIN, USER_NOTIFICATIONS, USER_DP, USER_DESCRIPTION)

  VALUES (UUID(), fName, lName, username, userEmail, userPass, isAdmin, wantsNotifications, userDP, userDescr);

  CALL retrieve_row_entry("`USER`", "USERNAME", username);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `open_tournament` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `open_tournament`(IN tournamentID VARCHAR(45))
BEGIN
	SET @tID = tournamentID;
    SET @toggleStmt = 'UPDATE TOURNAMENT
			SET TOURNAMENT_IS_OPEN = 1
            WHERE TOURNAMENT_ID = ?';
	
    PREPARE stmt FROM @toggleStmt;
    EXECUTE stmt USING @tID;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `remove_agent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `remove_agent`(IN agentID VARCHAR(45))
BEGIN
	-- Check if necessary to archive any agent details
    -- It is only necessary to delete an agent when it has participated in a match
    SET @aID = agentID;
    SET @checkStmt = '
		SELECT COUNT(*) 
        FROM AGENT 
        WHERE AGENT_ID = ? 
        INTO @pastCount';
    
    SET @countStmt = '
		SELECT COUNT(*) 
        FROM RANKING 
        WHERE AGENT_ID = ?
        INTO @currCount;';
	
     SET @archStmt= '
		SELECT COUNT(*) 
        FROM RANKING 
        WHERE AGENT_ID = ?
        INTO @archCount;';
        
	-- Check how many agents are being deleted
	PREPARE stmt FROM @checkStmt;
    EXECUTE stmt USING @aID;
    DEALLOCATE PREPARE stmt;
    
    -- Check how many matches an agent participated in
    PREPARE stmt FROM @countStmt;
    EXECUTE stmt USING @aID;
    DEALLOCATE PREPARE stmt;
    
    -- Check how many matches an agent participated in the past archives
    PREPARE stmt FROM @archStmt;
    EXECUTE stmt USING @aID;
    DEALLOCATE PREPARE stmt;
        
    IF (@currCount + @archCount) > 0 THEN
		CALL archive_agent(agentID);
	END IF;
        
	CALL delete_agent(agentID);
    
    SELECT @pastCount AS 'deleteCount';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `retrieve_row_entry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `retrieve_row_entry`(IN tableName VARCHAR(45), IN fieldName VARCHAR(45), IN fieldValue VARCHAR(45))
    COMMENT 'Retrieves a row entry from a particular table, using a candidate key with the requested value'
BEGIN

  SET @fieldVal = fieldValue;
  SET @stmt = CONCAT('SELECT * FROM ',tableName, ' WHERE ', fieldName, ' = ?');

  PREPARE queryID FROM @stmt;

  EXECUTE queryID USING @fieldVal;

  DEALLOCATE PREPARE queryID;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `start_live_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `start_live_game`(IN tournamentID VARCHAR(45))
    MODIFIES SQL DATA
    COMMENT 'Creates a live game'
BEGIN
  SET @matchLogTime = CURRENT_TIMESTAMP();
  SET @tID = tournamentID;
  SET @insertStmt = "INSERT INTO `MATCH_LOG`(MATCH_LOG_ID, TOURNAMENT_ID, MATCH_LOG_DATA, MATCH_LOG_TIMESTAMP, MATCH_LOG_IN_PROGRESS)
		VALUES (UUID(), ?, '', ?, 1)";
        
  PREPARE stmt FROM @insertStmt;
  EXECUTE stmt USING @tID, @matchLogTime;
  DEALLOCATE PREPARE stmt;

  CALL retrieve_row_entry("MATCH_LOG", "MATCH_LOG_TIMESTAMP", @matchLogTime);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `start_live_match` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `start_live_match`(IN tournamentID VARCHAR(45))
    MODIFIES SQL DATA
    COMMENT 'Creates a live game'
BEGIN
  SET @matchLogTime = CURRENT_TIMESTAMP();
  SET @tID = tournamentID;
  SET @insertStmt = "INSERT INTO `MATCH_LOG`(MATCH_LOG_ID, TOURNAMENT_ID, MATCH_LOG_DATA, MATCH_LOG_TIMESTAMP, MATCH_LOG_IN_PROGRESS)
		VALUES (UUID(), ?, '', ?, 1)";
        
  PREPARE stmt FROM @insertStmt;
  EXECUTE stmt USING @tID, @matchLogTime;
  DEALLOCATE PREPARE stmt;

  CALL retrieve_row_entry("MATCH_LOG", "MATCH_LOG_TIMESTAMP", @matchLogTime);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_agent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `update_agent`(IN setClause LONGTEXT, IN whereCondition LONGTEXT, IN retrievalWhereCondition LONGTEXT)
BEGIN
	SET @updateStmt = 
		CONCAT('UPDATE AGENT AS A 
			INNER JOIN AGENT_TOURNAMENT AS AGT ON (A.AGENT_ID = AGT.AGENT_ID)
			INNER JOIN ADDRESS AS AD ON (A.ADDRESS_ID = AD.ADDRESS_ID) ',
			setClause, ' ', whereCondition);
            
	PREPARE stmt FROM @updateStmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
    SET @getStmt =
		CONCAT('SELECT *
			FROM AGENT AS A 
				INNER JOIN AGENT_TOURNAMENT AS AGT ON (A.AGENT_ID = AGT.AGENT_ID)
				INNER JOIN ADDRESS AS AD ON (A.ADDRESS_ID = AD.ADDRESS_ID) ',
			retrievalWhereCondition);
            
	PREPARE stmt FROM @getStmt;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_agent_result` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `update_agent_result`(IN matchLogID VARCHAR(45), IN agentID VARCHAR (45), ranking INT)
BEGIN
	SET @mID = matchLogID;
    SET @aID = agentID;
    SET @r = ranking;
    
    SET @updateStmt = 'UPDATE RANKING
			SET RANKING = ?
            WHERE MATCH_LOG_ID = ? AND AGENT_ID = ?';
	
    PREPARE stmt FROM @updateStmt;
    EXECUTE stmt USING @r, @mID, @aID;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_query` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`admin`@`%` PROCEDURE `update_query`(IN tblName VARCHAR(45), IN setValues TEXT, IN whereCondition TEXT)
    MODIFIES SQL DATA
    COMMENT 'Performs an update to a particular set of values'
BEGIN

  SET @tName = tblName;
  SET @sValues = setValues;
  SET @wClause = whereCondition;
    
  SET @stmt = CONCAT("UPDATE ? SET ? WHERE ?;");
  
  PREPARE updateStmt FROM @stmt;
  EXECUTE updateStmt USING @tName, @sValues, @wClause;
  DEALLOCATE PREPARE updateStmt;
  
END ;;
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

-- Dump completed on 2022-07-28 16:09:53
