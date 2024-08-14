CREATE PROCEDURE [dbo].[uspInsertSMSSettings]
	@FKCompanyID Bigint,
	@API			Varchar(2000)
AS
Begin
	If Exists(Select FKCompanyID From tblSMSSettings where FKCompanyID=@FKCompanyID)
	Begin
		Update tblSMSSettings Set API=@API
		Where FKCompanyID=@FKCompanyID
	End
	Else
	Begin
		Insert Into tblSMSSettings(FKCompanyID,API)
		Values(@FKCompanyID,@API)
	End

	Select 1 as Result,'' as Msg
End