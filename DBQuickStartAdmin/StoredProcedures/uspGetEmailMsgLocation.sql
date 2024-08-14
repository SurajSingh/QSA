CREATE PROCEDURE [dbo].[uspGetEmailMsgLocation]
	@StrLocation Varchar(500)
AS
Begin
	Select 1 as Result,PKID,LocationName,IsEmail,IsMsg,BStatus
	From tblEmailMsgLocation
	where BStatus=1
	And (@StrLocation='' Or PKID in (Select item From dbo.FunSplitString(@StrLocation,',') Where Item<>''))
	

End