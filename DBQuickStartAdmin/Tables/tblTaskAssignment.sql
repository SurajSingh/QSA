CREATE TABLE [dbo].[tblTaskAssignment]
(
	 PKID                   BIGINT          NOT NULL,
     AssignDate             Date            Not NULL,
     FKTaskID               Bigint,
     FKEmpID                Bigint, 
     FKProjectID            Bigint, 
     BHrs                   DECIMAL (18,2),
     TimeTaken              DECIMAL (18,2),
     Description            NVARCHAR (2000),
     CurrentStatus          Varchar(50) Default 'Pending',
     FKManagerID            Bigint,  
     Remark                 NVarchar(2000),  
     FKProjectForecastingID Bigint, 
     FKCompanyID		    Bigint, 
     FKCreatedBy		    Bigint,	
	 FKLastModifiedBy       Bigint,	
	 CreationDate	        DateTime,
	 ModificationDate       DateTime,		
     BStatus                BIT   Default 1
)
