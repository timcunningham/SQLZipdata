/*****************************************************************************/
/**********************		ZIP TABLE	**************************************/
/*****************************************************************************/
if OBJECT_ID('tempdb..#TMP_ZIP') is not null
	DROP Table #TMP_ZIP

CREATE TABLE #TMP_ZIP (line varchar(500))

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'ZIP'))
BEGIN
   CREATE TABLE [ZIP] (
	[ZIP] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STATE] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CITY] [char] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TYP] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FIPS] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LAT] [float] NULL ,
	[LNG] [float] NULL ,
	[A_C] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FINANCE] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LL] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FAC] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MSA] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PMSA] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FILLER] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
END



TRUNCATE TABLE #TMP_ZIP

BULK INSERT #TMP_ZIP
FROM 'C:\ZipData\Zip.dat'
WITH (ROWTerminator = '\n')

TRUNCATE TABLE ZIP

INSERT [ZIP]
SELECT substring(line,1,5) as zip,
	substring(line,6,2) as state,
	substring(line,8,28) as city,
	substring(line,36,1) as typ,
	substring(line,38,5) as fips,
	substring(line,42,7) as lat,
	substring(line,49,8) as lng,
	substring(line,56,3) as A_C,
	substring(line,60,6) as finance,
	substring(line,66,1) as LL,
	substring(line,67,1) as FAC,
	substring(line,68,4) as MSA,
	substring(line,72,4) as PMSA,
	substring(line,76,3) as Filler
FROM #TMP_ZIP
WHERE substring(line,1,5) NOT IN ('00000', '99999')
ORDER BY 1 



/*****************************************************************************/
/**********************		ZIP COUNTY	**************************************/
/*****************************************************************************/

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'ZIP_COUNTY'))
BEGIN

	CREATE TABLE [ZIP_COUNTY] (
		[ZIP] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[FIPS] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[PERCENTAGE] [char] (6) NULL ,
		[COUNT] [char] (6) NULL
	) ON [PRIMARY]

END

TRUNCATE TABLE #TMP_ZIP
BULK INSERT #TMP_ZIP FROM 'C:\ZipData\ZIPCNTY.DAT' WITH (ROWTerminator = '\n')

Truncate TABLE [ZIP_COUNTY]

INSERT [ZIP_COUNTY]
SELECT substring(line,1,5) as zip,
	substring(line,6,5) as fips,
	substring(line,12,6) as percentage,
	substring(line,17,6) as [count]
FROM #TMP_ZIP
ORDER BY 1



/*****************************************************************************/
/**********************		Unique Zip Code	**********************************/
/*****************************************************************************/

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Unique'))
BEGIN

	CREATE TABLE [Unique] (
	[ZIP] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NAME] [char] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
) ON [PRIMARY]
END

TRUNCATE TABLE #TMP_ZIP
BULK INSERT #TMP_ZIP FROM 'C:\ZipData\UNQ.DAT' WITH (ROWTerminator = '\n')

Truncate TABLE [Unique]

INSERT [Unique]
SELECT substring(line,1,5) as zip,
	substring(line,6,28) as [Name]
FROM #TMP_ZIP
ORDER BY 1



/*****************************************************************************/
/**********************		County Name		**********************************/
/*****************************************************************************/

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'COUNTY'))
BEGIN

	CREATE TABLE [COUNTY] (
	[FIPS] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NAME] [char] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[STATE] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[T_Z] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CNTY_TYPE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[COUNTYSEAT] [char] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NAME_TYPE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ELEVATION] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PERNS_HOUS] [char] (4) NULL ,
	[POPULATION] [char] (8) NULL ,
	[AREA_SQ_MI] [char] (6) NULL ,
	[HOUSEHOLDS] [char] (8) NULL ,
	[WHITE] [char] (8) NULL ,
	[BLACK] [char] (8) NULL ,
	[HISPANIC] [char] (8) NULL ,
	[INCOM_HHLD] [char] (8) NULL ,
	[HOUSE_VAL] [char] (8) NULL 
) ON [PRIMARY]
END

TRUNCATE TABLE #TMP_ZIP

BULK INSERT #TMP_ZIP FROM 'C:\ZipData\CNTY.DAT' WITH (ROWTerminator = '\n')

Truncate TABLE COUNTY

INSERT COUNTY
SELECT substring(line,1,5) as fips,
	substring(line,6,25) as [Name],
	substring(line,31,2) as state,
	substring(line,33,2) as T_Z,
	substring(line,35,1) as cnty_type,
	substring(line,36,28) as countyseat,
	substring(line,64,1) as name_type,
	substring(line,65,5) as elevation,
	substring(line,70,4) as persn_hous,
	substring(line,75,8) as [population],
	substring(line,82,6) as area,
	substring(line,88,8) as households,
	substring(line,96,8) as white,
	substring(line,104,8) as black,
	substring(line,112,8) as hispanic,
	substring(line,120,8) as income,
	substring(line,128,8) as houseval
FROM #TMP_ZIP
ORDER BY 1


/**********************************************************************************************************/
/**********************		Metropolitian Statistical Area Database 	**********************************/
/********************************************************************************************************/

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'MSA'))
BEGIN

CREATE TABLE [MSA] (
	[CODE] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TYP] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NAME] [char] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CMSA] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[POP] [char] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
END

TRUNCATE TABLE #TMP_ZIP
BULK INSERT #TMP_ZIP FROM 'C:\ZipData\MSA.DAT' WITH (ROWTerminator = '\n')

Truncate TABLE MSA

INSERT MSA
SELECT substring(line,1,4) as code,
	substring(line,5,4) as [type],
	substring(line,9,60) as [name],
	substring(line,69,2) as CMSA,
	substring(line,71,1) as pop
FROM #TMP_ZIP
ORDER BY 1


/*****************************************************************************/
/**********************		Delivery Statistics	**********************************/
/*****************************************************************************/

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'DEL_STATS'))
BEGIN

	CREATE TABLE [DEL_STATS] (
	[ZIP] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RES] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL , 
	[RES_POB] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL , 
        [BUS] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL , 
	[BUS_POB] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL , 
	[GRP_DEL] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL , 
	[GEN_DEL] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
END

TRUNCATE TABLE #TMP_ZIP
BULK INSERT #TMP_ZIP FROM 'C:\ZipData\DST.DAT' WITH (ROWTerminator = '\n')

Truncate TABLE [DEL_STATS]

INSERT [DEL_STATS]
SELECT substring(line,1,5) as zip,
	substring(line,6,6) as residence,
    substring(line,12,6) as residence_PO_box,
    substring(line,18,6) as business,
    substring(line,24,6) as business_PO_box,
    substring(line,30,6) as business_Group_Delivery,
    substring(line,36,6) as generalDelivery

FROM #TMP_ZIP
ORDER BY 1


/**********************************************************************************************/
/**********************		City Name Abbreviation Database	**********************************/
/********************************************************************************************/

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'CITY_ABB'))
BEGIN

CREATE TABLE [CITY_ABB] (
	[ZIP] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CITY] [char] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ABB] [char] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

END

TRUNCATE TABLE #TMP_ZIP
BULK INSERT #TMP_ZIP FROM 'C:\ZipData\ABB.DAT' WITH (ROWTerminator = '\n')

Truncate TABLE [CITY_ABB]

INSERT [CITY_ABB]
SELECT substring(line,1,5) as zip,
	substring(line,6,28) as city,
    substring(line,34,13) as abbreviation
    
FROM #TMP_ZIP
ORDER BY 1



/**********************************************************************************************/
/**********************		Census  Database	**********************************************/
/********************************************************************************************/

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Census'))
BEGIN

CREATE TABLE [CENSUS] (
	[ZIP] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	
	[POPULATION] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[URBAN] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SUBURBAN] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FARM] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NONFARM] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[WHITE] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BLACK] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[INDIAN] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ASIAN] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HAWAIIAN] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RACE_OTHER] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HISPANIC] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_0_4] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_5_9] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_10_14] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_15_17] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_18_19] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_20] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_21] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_22_24] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_25_29] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_30_34] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_35_39] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_40_44] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_45_49] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_50_54] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_55_59] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_60_61] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_62_64] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_65_66] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_67_69] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_70_74] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_75_79] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_80_84] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AGE_85_PLS] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EDU_LESS9] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EDU_9_12] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EDU_HIGHSC] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EDU_SOMECL] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EDU_ASSOC] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EDU_BACH] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EDU_PROF] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HH_INCOME] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PC_INCOME] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HOUSE_VAL] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
END

TRUNCATE TABLE #TMP_ZIP
BULK INSERT #TMP_ZIP FROM 'C:\ZipData\Census.DAT' WITH (ROWTerminator = '\n')

Truncate TABLE [Census]

INSERT [Census]
SELECT substring(line,1,5) as zip,
	substring(line,6,6),
    substring(line,12,6),
    substring(line,18,6),
    substring(line,24,6),
    substring(line,30,6),
    substring(line,36,6),
    substring(line,42,6),
    substring(line,48,6),
    substring(line,54,6),
    substring(line,60,6),
    substring(line,66,6),
    substring(line,72,6),
    substring(line,78,6),
    substring(line,84,6),
    substring(line,90,6),
    substring(line,96,6),
    substring(line,102,6),
    substring(line,108,6),
    substring(line,114,6),
    substring(line,120,6),
    substring(line,126,6),
    substring(line,132,6),
    substring(line,138,6),
    substring(line,144,6),
    substring(line,150,6),
    substring(line,156,6),
    substring(line,162,6),
    substring(line,168,6),
    substring(line,174,6),
    substring(line,180,6),
    substring(line,186,6),
    substring(line,192,6),
    substring(line,198,6),
    substring(line,204,6),
    substring(line,210,6),
    substring(line,216,6),
    substring(line,222,6),
    substring(line,228,6),
    substring(line,234,6),
    substring(line,240,6),
    substring(line,246,6),
    substring(line,252,6),
    substring(line,258,6),
    substring(line,264,6),
    substring(line,270,6)
FROM #TMP_ZIP
ORDER BY 1

/**********************************************************************************************/
/**********************		Core Based Statistical Area Database  ****************************/
/********************************************************************************************/

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'CBSA'))
BEGIN

CREATE TABLE [CBSA] (
	[CODE] [char] (5),
	[TYPE] [char] (4),
	[TITLE] [char] (50),
	[LEVEL] [char] (29),
	[STATUS] [char] (1)
) ON [PRIMARY]
END

TRUNCATE TABLE #TMP_ZIP
BULK INSERT #TMP_ZIP FROM 'C:\ZipData\CBSA.DAT' WITH (ROWTerminator = '\n')

Truncate TABLE [CBSA]

INSERT [CBSA]
SELECT substring(line,1,5) as [code],
	substring(line,6,4) as [type],
    substring(line,10,50) as title,
    substring(line,60,29) as [level],
    substring(line,89,1) as status
    
FROM #TMP_ZIP
ORDER BY 1


/**********************************************************************************************/
/**********************		ZIP / CBSA   *****************************************************/
/********************************************************************************************/

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'ZIPCBSA'))
BEGIN
CREATE TABLE [ZIPCBSA] (
	[ZIP] [char] (5), 
	[CBSA] [char] (5), 
	[DIV] [char] (5) 
) ON [PRIMARY]
END

TRUNCATE TABLE #TMP_ZIP
BULK INSERT #TMP_ZIP FROM 'C:\ZipData\ZIPCBSA.DAT' WITH (ROWTerminator = '\n')

Truncate TABLE [ZIPCBSA]

INSERT [ZIPCBSA]
SELECT substring(line,1,5) as zip,
	substring(line,6,5) as cbsa,
    substring(line,11,5) as div
FROM #TMP_ZIP
ORDER BY 1

DROP TABLE #TMP_ZIP
