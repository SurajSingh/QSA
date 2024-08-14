CREATE TABLE [dbo].[tblStateMaster]
(
	PKStateID	Bigint		Not Null,
	FKCountryID	Bigint		Not Null,
	StateName	Varchar(50)	Not Null,
	StateCode	Varchar(10),
	TraficCode	Varchar(10)
)
