/*****************************************************************************/
/**********************		ZIP TABLE	**************************************/
/*****************************************************************************/

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

if OBJECT_ID('tempdb..#TMP_ZIP') is not null
	DROP Table #TMP_ZIP

CREATE TABLE #TMP_ZIP
(line varchar(500))

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

if OBJECT_ID('tempdb..#TMP_ZIP') is not null
	DROP Table #TMP_ZIP

CREATE TABLE #TMP_ZIP (line varchar(500))
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

if OBJECT_ID('tempdb..#TMP_ZIP') is not null
	DROP Table #TMP_ZIP

CREATE TABLE #TMP_ZIP (line varchar(500))
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

if OBJECT_ID('tempdb..#TMP_ZIP') is not null
	DROP Table #TMP_ZIP

CREATE TABLE #TMP_ZIP (line varchar(500))
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
