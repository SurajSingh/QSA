CREATE TABLE [dbo].[tblPayrollSetting]
(
	PKID				BIGINT NOT NULL,
	FKCompanyID			BIGINT, 
	StartMonth			Varchar(2),
	EndMonth			Varchar(2),
	LeaveRule			Bigint,
	CreationDate	    DateTime,
	ModificationDate    DateTime
)
