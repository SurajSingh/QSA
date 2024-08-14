CREATE PROCEDURE [dbo].[uspInsertLog]

	@FKUserID	Bigint,
	@FKPageID	Bigint,
	@IPAddress	Varchar(50),		
	@Operation	Varchar(500),
	@FKID		Bigint
AS
	Begin
		Insert Into tblUserLog(FKUserID,FKPageID,IPAddress,Operation,FKID,LogDate)
		Values(@FKUserID,@FKPageID,@IPAddress,@Operation,@FKID,GETUTCDATE())
	End

