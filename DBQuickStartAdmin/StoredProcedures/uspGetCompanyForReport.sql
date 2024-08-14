CREATE PROCEDURE [dbo].[uspGetCompanyForReport]
	
	@PKCompanyID		Bigint
AS
Begin
	
	Select 1 as Result, A.Address1, A.Address2, A.ZIP, A.Mobile, A.Phone, A.Email, A.CPerson, A.CPersonTitle, A.GSTNo, A.PANNo, A.LogoURL,A.SmallLogoURL,A.Fax, A.Website,	
		Isnull(ADC.CountryName,'') as CountryName,Isnull(ADS.StateName,'') as StateName,ISnull(ADC1.CityName,'') as CityName,	
		Isnull(ADT.TahsilName,'') TahsilName,ADS.StateCode,
		CU.Symbol,A.CompanyName,A.CompanyName as CompanyOrBranch
		From tblCompany A		
		Left Join tblCountryMaster ADC on ADC.PKCountryID=A.FKCountryID
		Left Join tblStateMaster ADS on ADS.PKStateID=A.FKStateID
		Left Join tblCityMaster ADC1 on ADC1.PKCityID=A.FKCityID
		Left Join tblTahsilMaster ADT on ADT.PKTahsilID=A.FKTahsilID
		Left Join tblCurrencyMaster CU on A.FKCurrencyID=CU.PKCurrencyID	
		Where  A.PKCompanyID=@PKCompanyID
End
