CREATE TABLE [dbo].[tblErrorLogs]
(
	FKUserID Bigint,
	ErrorType Varchar(5),
	ErrorModule Varchar(100),
	ErrorDesc NVarchar(2000),
	IPAddress Varchar(50),
	CreationDate DateTime
)
