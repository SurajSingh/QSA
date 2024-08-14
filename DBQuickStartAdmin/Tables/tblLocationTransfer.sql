CREATE TABLE [dbo].[tblLocationTransfer]
(
	PKID				Bigint NOT NULL,
	TranDate			Date,
	SNo					Bigint,
	EntryID				Varchar(50),
	FKAssetID			Bigint, 
	FKLocationID		Bigint, 
	FKDeptID			Bigint,
	FKEmpID				Bigint,
	FKRepairPartyID		Bigint,
	FKPrevID			Bigint, 
	Remarks				Varchar(max),
	FKCompanyID			Bigint, 
    FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime,
	ModificationDate	DateTime

)
