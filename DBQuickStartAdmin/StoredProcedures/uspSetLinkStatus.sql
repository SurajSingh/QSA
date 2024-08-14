CREATE PROCEDURE [dbo].[uspSetLinkStatus]
	@PKID	Bigint,
	@ActiveStatus Varchar(1)
AS
Begin
	Update tblLink Set ActiveStatus=@ActiveStatus Where PKID=@PKID
	Select 1 as Result
End