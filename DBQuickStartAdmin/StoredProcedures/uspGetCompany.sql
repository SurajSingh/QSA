CREATE PROCEDURE [dbo].[uspGetCompany]
	@PKCompanyID Bigint
AS
Begin
	Select 1 as Result,A.PKCompanyID, A.CompanyID, A.CompanyName, A.Address1, A.Address2, Isnull(A.FKTahsilID,0) as FKTahsilID, Isnull(A.FKCityID,0) as FKCityID, 
	Isnull(A.FKStateID,0) as FKStateID, A.FKCountryID, A.ZIP, A.Mobile, A.Phone, A.Email, A.CPerson, A.CPersonTitle, A.GSTNo, A.PANNo, A.LogoURL,A.SmallLogoURL, A.RegDate,A.FKTimezoneID, A.FKCurrencyID, A.DateForStr, 
	A.CreationDate, A.ModificationDate,A.Website,	
	Isnull(ADC.CountryName,'') as CountryName,Isnull(ADS.StateName,'') as StateName,ISnull(ADC1.CityName,'') as CityName,
	ISnull(ADT.TahsilName,'') as TahsilName,A.InvoicePrefix,A.InvoiceSNo,A.InvoiceSuffix,A.InvoiceTempID,Isnull(A.AttenUserName,'') as AttenUserName,Isnull(A.AttenPWD,'') as AttenPWD
	From tblCompany A
	
	Left Join tblCountryMaster ADC on A.FKCountryID=ADC.PKCountryID
	Left Join tblStateMaster ADS on A.FKStateID=ADS.PKStateID
	Left Join tblCityMaster ADC1 on A.FKCityID=ADC1.PKCityID
	Left Join tblTahsilMaster ADT on A.FKTahsilID=ADT.PKTahsilID
	Where A.PKCompanyID=@PKCompanyID
	Order by a.CreationDate
End
