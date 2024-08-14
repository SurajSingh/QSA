CREATE PROCEDURE [dbo].[uspGetCountry]
	@PKID Bigint
AS
Begin
	Select PKCountryID, CountryName From tblCountryMaster
	Where (PKCountryID=@PKID Or @PKID=0)
	Order By CountryName
End