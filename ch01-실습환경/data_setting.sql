/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


CREATE DATABASE IF NOT EXISTS `tuning` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `tuning`;


CREATE TABLE IF NOT EXISTS `SALARY` ( -- 급여
  `EMP_ID`        int NOT NULL,       -- 사원번호
  `ANNUAL_SALARY` int NOT NULL,       -- 연봉
  `START_DATE`    date NOT NULL,      -- 시작일자
  `END_DATE`      date NOT NULL,      -- 종료일자
  `IS_YN`         char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '', -- 사용여부
  PRIMARY KEY (`EMP_ID`,`START_DATE`),
  KEY `I_IS_YN` (`IS_YN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE IF NOT EXISTS `DEPT` (  -- 부서
  `DEPT_ID`   char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,         -- 부서번호
  `DEPT_NAME` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,     -- 부서명
  `REMARK`    varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL, -- 비고
  PRIMARY KEY (`DEPT_ID`) USING BTREE,                -- 부서번호
  UNIQUE KEY `UI_DEPT_NAME` (`DEPT_NAME`) USING BTREE -- 부서명
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `MANAGER` ( -- 부서관리자
  `EMP_ID`     int NOT NULL,                                                -- 사원번호
  `DEPT_ID`    char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, -- 부서번호
  `START_DATE` date NOT NULL,  -- 시작일자
  `END_DATE`   date NOT NULL,  -- 종료일자
  PRIMARY KEY (`EMP_ID`,`DEPT_ID`) USING BTREE,
  KEY `I_DEPT_ID` (`DEPT_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `DEPT_EMP_MAPPING` ( -- 부서사원_매핑
  `EMP_ID`     int NOT NULL,                                                -- 사원번호
  `DEPT_ID`    char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, -- 부서번호
  `START_DATE` date NOT NULL, -- 시작일자
  `END_DATE`   date NOT NULL, -- 종료일자
  PRIMARY KEY (`EMP_ID`,`DEPT_ID`) USING BTREE,
  KEY `I_DEPT_ID` (`DEPT_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `EMP` ( -- 사원
  `EMP_ID` int NOT NULL,           -- 사원번호
  `BIRTH`  date NOT NULL,          -- 생년월일
  `FIRST_NAME` varchar(14) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,          -- 이름
  `LAST_NAME`  varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,   -- 성
  `GENDER`     enum('M','F') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, -- 성별
  `HIRE_DATE`  date NOT NULL,                                                     -- 입사일자
  PRIMARY KEY (`EMP_ID`) USING BTREE,
  KEY `I_HIRE_DATE` (`HIRE_DATE`) USING BTREE,  
  KEY `I_GENDER_LAST_NAME` (`GENDER`,`LAST_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `ENTRY_RECORD` ( -- 사원출입기록
  `NO`         int NOT NULL AUTO_INCREMENT,                  -- 순번
  `EMP_ID`     int NOT NULL,                                 -- 사원번호
  `ENTRY_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 출입시간
  `INOUT`  char(1) NOT NULL,     -- 출입유형(IN / OUT)
  `GATE`   char(1) DEFAULT NULL, -- 출입문
  `REGION` char(1) DEFAULT NULL, -- 지역
  PRIMARY KEY (`NO`,`EMP_ID`) USING BTREE,
  KEY `I_REGION` (`REGION`),
  KEY `I_ENTRY_TIME` (`ENTRY_TIME`),
  KEY `I_GATE` (`GATE`)
) ENGINE=InnoDB AUTO_INCREMENT=1508154 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `GRADE` ( -- 직급
  `EMP_ID`     int NOT NULL,                                                    -- 사원번호
  `GRADE_NAME` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, -- 직급명
  `START_DATE` date NOT NULL,     -- 시작일자
  `END_DATE`   date DEFAULT NULL, -- 종료일자
  PRIMARY KEY (`EMP_ID`,`GRADE_NAME`,`START_DATE`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;


SELECT 'LOADING emp.sql' as 'INFO';
source emp.sql ;
SELECT 'LOADING dept.sql' as 'INFO';
source dept.sql ;
SELECT 'LOADING emp_hist1.sql' as 'INFO';
source emp_hist1.sql ;
SELECT 'LOADING emp_hist2.sql' as 'INFO';
source emp_hist2.sql ;
SELECT 'LOADING grade.sql' as 'INFO';
source grade.sql ;
SELECT 'LOADING sal1.sql' as 'INFO';
source sal1.sql ;
SELECT 'LOADING sal2.sql' as 'INFO';
source sal2.sql ;
SELECT 'LOADING sal3.sql' as 'INFO';
source sal3.sql ;
SELECT 'LOADING sal4.sql' as 'INFO';
source sal4.sql ;
SELECT 'LOADING sal5.sql' as 'INFO';
source sal5.sql ;
SELECT 'LOADING sal6.sql' as 'INFO';
source sal6.sql ;
