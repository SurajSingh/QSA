CREATE PROCEDURE [dbo].[uspGetTahsil]
	@FKCityID Bigint,
	@PKID	  Bigint
AS
Begin
	Select PKTahsilID,TahsilName from tblTahsilMaster
	Where (FKCityID=@FKCityID Or @FKCityID=0)
	And (PKTahsilID=@PKID Or @PKID=0)
	Order By TahsilName
End