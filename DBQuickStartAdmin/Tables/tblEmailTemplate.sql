CREATE TABLE [dbo].[tblEmailTemplate]
(
	FKEmailMsgLocID		Bigint, 
	FKCompanyID			Bigint, 
	EmailSubject		NVarchar(2000),
	BodyContent			NVarchar(max),
	EnableEmail			Bit,	
	Receiver			Varchar(2000)

)
