CREATE PROCEDURE [dbo].[uspGetCity]
	@FKStateID		Bigint,
	@PKID			Bigint
AS
Begin
Select A.PKCityID, A.FKStateID, A.CityName From tblCityMaster A
Where (A.FKStateID=@FKStateID or @FKStateID=0)
And (@PKID=0 Or A.PKCityID=@PKID)
order by A.CityName
End