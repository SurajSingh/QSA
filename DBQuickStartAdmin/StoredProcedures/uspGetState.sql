CREATE PROCEDURE [dbo].[uspGetState]
	@FKCountryID Bigint=0,
	@PKID			Bigint
AS
Begin
	Select PKStateID, FKCountryID, StateName,StateCode,TraficCode From tblStateMaster
	Where (FKCountryID=@FKCountryID OR @FKCountryID=0)
	And (PKStateID=@PKID Or @PKID=0)
	Order BY StateName
End