CREATE TABLE dbo.tblTask
(
	PKID		       Bigint Not Null,
	TaskCode           VARCHAR (50)    NULL,
    TaskName           VARCHAR (100)   NULL,
    Description        VARCHAR (500)   NULL,
    IsBillable         BIT             NULL,
    ActiveStatus       VARCHAR (50)    NULL,   
    FKDeptID           Bigint          NULL,             
    CostRate           DECIMAL (18, 4) NULL,
    BillRate           DECIMAL (18, 4) NULL,
    TEType             VARCHAR (50)    NULL,
    Tax                DECIMAL (18, 4) NOT NULL,
    BHours             DECIMAL (18, 4) NOT NULL,
    isReimb            BIT             NULL,
    MuRate             DECIMAL (18, 4) NULL,
    RecType            VARCHAR (50)    NULL,    
    FKCompanyID		   Bigint, 
    FKCreatedBy		   Bigint,	
	FKLastModifiedBy   Bigint,	
	CreationDate	   DateTime,
	ModificationDate   DateTime,		
    BStatus            BIT   Default 1
)
