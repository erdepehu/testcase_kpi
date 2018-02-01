-- MySQL dump 10.13  Distrib 5.5.35, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: test_results
-- ------------------------------------------------------
-- Server version	5.5.35-0ubuntu0.12.04.2
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'test_results'
--
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` FUNCTION `get_latest_versionid_f`( projectidin INT(10), testcasetypeidin INT(10) ) RETURNS int(11)
BEGIN
	DECLARE version_ integer;

	SELECT ver.VersionID INTO version_
	FROM 
		Test as t
	INNER JOIN Version as ver ON (ver.VersionID = t.VersionID)
	WHERE  
		ProjectID = projectidin AND
		TestCaseTypeID = testcasetypeidin
	ORDER BY INET_ATON(SUBSTRING_INDEX(CONCAT(ver.VersionName,'.0.0.0.0.0'),'.',6)) DESC 

	LIMIT 1  ;
	RETURN version_;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` FUNCTION `sort_by_version_number`() RETURNS int(11)
BEGIN
DECLARE res INT ;
SELECT VersionID INTO res FROM Version ORDER BY INET_ATON(SUBSTRING_INDEX(CONCAT(VersionName,'.0.0.0.0.0'),'.',6)) DESC LIMIT 1;
RETURN res;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `all_testcases`(testcasetypeid INT(10))
BEGIN

	SELECT count( * )
	FROM
	(
		SELECT * FROM Test
		where Test.TestCaseTypeID = testcasetypeid
	) AS cnt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `all_testcases_by_revision`(projectid INT(10), testcasetypeid__ INT(10))
BEGIN
	SELECT count( * )
	FROM
	(
		SELECT * FROM test_results.Test
		where RevisionID = (
			SELECT RevisionID 
			FROM Test 
			where test_results.Test.TestCaseTypeID = testcasetypeid__ and test_results.Test.ProjectID = projectid 
			ORDER BY RevisionID DESC  LIMIT 1  
		) and test_results.Test.TestCaseTypeID = testcasetypeid__ and test_results.Test.ProjectID = projectid
	) AS DESCA;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `all_testcases_by_version`(projectid INT(10), testcasetypeid__ INT(10))
BEGIN
	DECLARE  version_id integer;
	SELECT get_latest_versionid_f( projectid, testcasetypeid__ ) INTO version_id ;
	SELECT count(*)
	FROM
	(
		SELECT TestID
		FROM test_results.Test
		WHERE VersionID = version_id 
		AND 
		test_results.Test.TestCaseTypeID = testcasetypeid__ AND test_results.Test.ProjectID = projectid
		GROUP BY TestCaseID
	) AS GR;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `DOORS`( projectidin INT(10), testcasetypeidin INT(10) )
BEGIN
	DECLARE  version_id integer;
	SELECT get_latest_versionid_f( projectidin, testcasetypeidin ) INTO version_id ;

	SELECT *
	FROM(
		SELECT
			version.VersionName    				AS Version, 
			doors.DOORS_ScenarioID 				AS DOORS_ScenarioID,
			testcase.TestCaseName  				AS TestCaseName,
			result.ResultName      				AS ResultName,
			doors.ReqIDs           				AS System_Requirements, 
			scenario.ScenarioID    				AS ScenarioID
		FROM 
			test_results.Test AS test
		INNER JOIN 
			test_results.Result   AS result   ON ( test.ResultID   = result.ResultID     )
		INNER JOIN 
			test_results.TestCase AS testcase ON ( test.TestCaseID = testcase.TestCaseID )
		INNER JOIN 
			test_results.Version AS version ON ( test.VersionID = version.VersionID )
 		INNER JOIN 
			guitest_omnibb.Scenario  AS scenario   ON ( testcase.TestCaseName   = scenario.Description     )  
 		INNER JOIN 
			guitest_omnibb.Scenario_with_sentence  AS scen_with_sent   ON ( scenario.ScenarioID   = scen_with_sent.ScenarioID     )  
 		INNER JOIN 
			guitest_omnibb.Complete_sentence  AS complete_sentence   ON ( scen_with_sent.CompleteSentenceID   = complete_sentence.CompleteSentenceID     )  
 		INNER JOIN 
			guitest_omnibb.DOORS_Scenario  AS doors   ON ( scenario.DOORS_ScenarioID   = doors.DOORS_ScenarioID     )   
		WHERE 
			test.ProjectID = projectidin AND 
			test.TestCaseTypeID = testcasetypeidin AND 
			test.VersionID = version_id
		ORDER BY testcase.TestCaseName, test.LastRunning DESC
	) AS orderes_tcs
	GROUP BY 
		TestCaseName
	ORDER BY TestCaseName 
;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `get_latest_revision_by_ProjectID_and_TestCaseTypeID`( projectidin INT(10), testcasetypeidin INT(10) )
BEGIN
	SELECT RevisionID FROM Test where ProjectID = projectidin and TestCaseTypeID = testcasetypeidin
	ORDER BY RevisionID DESC  LIMIT 1  ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `get_latest_version_by_ProjectID_and_TestCaseTypeID`( projectidin INT(10), testcasetypeidin INT(10) )
BEGIN
	DECLARE  version_id integer;
	SELECT get_latest_versionid_f( projectidin, testcasetypeidin ) INTO version_id ;

	SELECT VersionName FROM
	Version
	WHERE
	VersionID = (
		SELECT VersionID
		FROM   Test
		WHERE  
			ProjectID = projectidin and 
			TestCaseTypeID = testcasetypeidin AND 
			VersionID = version_id
		LIMIT 1
	)
	LIMIT 1  ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `get_testcases_by_projectID_testcasetypeID`( projectidin INT(10), testcasetypeidin INT(10) )
BEGIN
	DECLARE  version_id integer;
	SELECT get_latest_versionid_f( projectidin, testcasetypeidin ) INTO version_id ;

	SELECT *
	FROM(
		SELECT
			testcase.TestCaseName AS TestCaseName,
			LENGTH(testcase.TestCaseName),
			result.ResultName     AS ResultName,
			test.ResultID         AS ResultID
		FROM 
			Test AS test
		INNER JOIN 
			TestCase AS testcase ON ( test.TestCaseID = testcase.TestCaseID )
		INNER JOIN 
			Result   AS result   ON ( test.ResultID   = result.ResultID     )

		WHERE 
			test.ProjectID = projectidin AND 
			test.TestCaseTypeID = testcasetypeidin AND 
			test.VersionID = version_id
		ORDER BY testcase.TestCaseName, test.LastRunning DESC
	) AS orderes_tcs
	GROUP BY 
		TestCaseName
	ORDER BY ResultID DESC, TestCaseName 
;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `get_testcases_by_version`(projectid INT(10), testcasetypeid INT(10))
SELECT count( * )
	FROM
	(
		SELECT * FROM test_results.Test
		where VersionID = (
			SELECT VersionID 
			FROM Version 
			ORDER BY VersionName DESC  LIMIT 1  
		) and 
		test_results.Test.TestCaseTypeID = testcasetypeid and test_results.Test.ProjectID = projectid  ORDER BY TestID DESC
	) AS DESCA; ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `passed_testcases_by_revision`( projectid INT(10), testcasetypeid INT(10) )
BEGIN
	SELECT count( * )
	FROM
	(
		SELECT * FROM test_results.Test
		where RevisionID = (
			SELECT RevisionID 
			FROM Test 
			where test_results.Test.ProjectID = projectid and test_results.Test.TestCaseTypeID = testcasetypeid 
			ORDER BY RevisionID DESC  
			LIMIT 1  
		) and ResultID = 1 and test_results.Test.ProjectID = projectid and test_results.Test.TestCaseTypeID = testcasetypeid
	) AS DESCA;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `passed_testcases_by_version`( projectid_in INT(10), testcasetypeid_in INT(10) )
BEGIN
	DECLARE  version_id integer;
	SELECT get_latest_versionid_f( projectid_in, testcasetypeid_in ) INTO version_id ;
	SELECT count(*)
	FROM
	(
		SELECT TestCaseID, ResultID
		FROM
		(
			SELECT TestCaseID, ResultID
			FROM test_results.Test
			WHERE VersionID = version_id
			AND test_results.Test.TestCaseTypeID = testcasetypeid_in 
			AND test_results.Test.ProjectID = projectid_in
			ORDER BY TestCaseID, LastRunning DESC
		) AS GR1
		GROUP BY TestCaseID
	) AS GR
	WHERE 
		ResultID = 1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `pass_fail_rate`( IN test_type CHAR(20), IN version CHAR(20) , IN project_name CHAR(20) )
BEGIN
SELECT 
((
SELECT
count( result.ResultName ) CNT_P
FROM Test AS test
JOIN TestCase AS testcase ON ( test.TestcaseID = testcase.TestcaseID )
JOIN TestCaseType AS testcasetype ON ( testcase.TestCaseTypeID = testcasetype.TestCaseTypeID )
JOIN Result AS result ON ( test.ResultID = result.ResultID )

JOIN Project AS project ON ( test.ProjectID = project.ProjectID )
JOIN Version AS version ON ( test.VersionID = version.VersionID )
where project.ProjectName = project_name and testcasetype.TestCaseTypeName = test_type and version.VersionName = version and result.ResultID = 1
) /
(
SELECT
count( result.ResultName ) CNT_F
FROM Test AS test
JOIN TestCase AS testcase ON ( test.TestcaseID = testcase.TestcaseID )
JOIN TestCaseType AS testcasetype ON ( testcase.TestCaseTypeID = testcasetype.TestCaseTypeID )
JOIN Result AS result ON ( test.ResultID = result.ResultID )

JOIN Project AS project ON ( test.ProjectID = project.ProjectID )
JOIN Version AS version ON ( test.VersionID = version.VersionID )
where project.ProjectName = project_name and testcasetype.TestCaseTypeName = test_type and version.VersionName = version and result.ResultID = 1
)  )AS PASS_FAIL_RATE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `pass_fail_rate_by_revision`( IN projectid CHAR(20) )
BEGIN
SELECT
(
	(
		SELECT count( * )
		FROM
		(
			SELECT * FROM test_results.Test
			where RevisionID = (
			SELECT RevisionID FROM Test ORDER BY RevisionID DESC  LIMIT 1  
			) and ProjectID = projectid and ResultID = 1 ORDER BY TestID DESC
		) AS DESCA 
	)
/
	(
		SELECT count( * )
		FROM
		(
			SELECT * FROM test_results.Test
			where RevisionID = (
			SELECT RevisionID FROM Test ORDER BY RevisionID DESC  LIMIT 1  
			) and ProjectID = projectid and ResultID = 1 ORDER BY TestID DESC
		) AS DESCA 
	)
);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`deveushu`@`172.30.36.%` PROCEDURE `pass_fail_rate_by_revision_and_testcase`( IN testcaseid CHAR(20), IN projectid CHAR(20) )
BEGIN
SELECT
(
	(
		SELECT count( * )
		FROM
		(
			SELECT * FROM test_results.Test
			where RevisionID = (
			SELECT RevisionID FROM Test ORDER BY RevisionID DESC  LIMIT 1  
			) and ProjectID = projectid and ResultID = 1 ORDER BY TestID DESC
		) AS DESCA where TestCaseID = testcaseid
	)
/
	(
		SELECT count( * )
		FROM
		(
			SELECT * FROM test_results.Test
			where RevisionID = (
			SELECT RevisionID FROM Test ORDER BY RevisionID DESC  LIMIT 1  
			) and ProjectID = projectid and ResultID = 1 ORDER BY TestID DESC
		) AS DESCA where TestCaseID = testcaseid	
	)
);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-05-28 14:04:42
