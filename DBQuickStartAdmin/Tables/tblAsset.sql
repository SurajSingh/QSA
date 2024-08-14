CREATE TABLE [dbo].[tblAsset]
(
	PKID				Bigint Not Null,
	AssetCode			Varchar(50),
	AssetName			Varchar(50),
	AssetDesc			Varchar(500),
	FKCategoryID		Bigint, 
	Manufacturer		Varchar(50),
	FKPartyID			Bigint, 
	PurchaseRate		Decimal(18,4),
	CurrentRate			Decimal(18,4),
	PurchaseDate		Date,
	InvoiceID			Varchar(50),
	PONo				Varchar(50),
	Barcode				Varchar(50),
	SerialNo			Varchar(50),
	Remarks				Varchar(50),
	ImgURL				Varchar(50),
	FKConditionID		Bigint, 
	FKLocationID		Bigint,
	FKDeptID			Bigint,
	FKEmpID				Bigint,
	FKRepairPartyID		Bigint,
	FKCompanyID			Bigint, 
    FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime,
	ModificationDate	DateTime



)
