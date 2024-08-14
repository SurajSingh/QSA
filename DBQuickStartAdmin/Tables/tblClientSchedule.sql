CREATE TABLE [dbo].[tblClientSchedule]
(
	PKID				Bigint Not Null,	
	FKProjectID			Bigint, 
	FromDate			Date,
	ToDate				Date,
	FromTime			Time,
	FKWorkTypeID		Bigint, 
	FKStatusID			Bigint, 
	Remarks				NVarchar(2000),
	FKCompanyID			Bigint,
	FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime	Not Null,
	ModificationDate	DateTime,	
    BStatus             BIT   Default 1 
)
