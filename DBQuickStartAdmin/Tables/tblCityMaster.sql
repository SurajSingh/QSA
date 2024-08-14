CREATE TABLE [dbo].[tblCityMaster]
(
	PKCityID	Bigint	Not Null,
	FKStateID	Bigint	Not Null,
	CityName	Varchar(50)	Not Null
)
