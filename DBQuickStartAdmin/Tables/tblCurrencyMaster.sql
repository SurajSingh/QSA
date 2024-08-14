CREATE TABLE [dbo].[tblCurrencyMaster]
(
	PKCurrencyID		Bigint				Not Null,
	Symbol				NVarchar(50)			Not Null,
	ShortName			Varchar(5),
	FullName			Varchar(50)	
)
