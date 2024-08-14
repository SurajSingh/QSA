CREATE PROCEDURE [dbo].[uspLogout]
	@FKUserID Bigint,	
	@IPAddress Varchar(50),
	@MACAddress Varchar(50)
AS
Begin
	Exec uspInsertLog @FKUserID,0,@IPAddress,'Logout',0
End
