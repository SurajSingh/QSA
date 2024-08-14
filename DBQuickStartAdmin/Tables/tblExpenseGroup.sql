CREATE TABLE [dbo].[tblExpenseGroup]
(
	[PKID]              BIGINT         NOT NULL,
    [GroupName]         VARCHAR (200)  NULL,
    [Description]       VARCHAR (5000) NULL,
    FKCompanyID		    Bigint, 
    FKCreatedBy		    Bigint,	
	FKLastModifiedBy    Bigint,	
	CreationDate	    DateTime,
	ModificationDate    DateTime,	
    BStatus             BIT   Default 1 
)
