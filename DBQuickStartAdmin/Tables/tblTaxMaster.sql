CREATE TABLE [dbo].[tblTaxMaster]
(
	PKID		        Bigint Not Null,
	[TaxName]           VARCHAR (50)    NULL,
    [TaxPercentage]     DECIMAL (18, 4) NULL,
    FKCompanyID			Bigint, 
    FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime,
	ModificationDate	DateTime,		
    [BStatus]           BIT   Default 1
)
