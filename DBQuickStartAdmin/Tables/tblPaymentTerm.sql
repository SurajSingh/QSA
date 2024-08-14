CREATE TABLE [dbo].[tblPaymentTerm]
(
	PKID				Bigint Not Null,
    [TermTitle]			NVARCHAR (200),
	[PayTerm]			NVARCHAR (Max),
    [GraceDays]			BIGINT  ,
	FKCompanyID			Bigint, 
    FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime,
	ModificationDate	DateTime,		
    [BStatus]			BIT    Default 1
)
