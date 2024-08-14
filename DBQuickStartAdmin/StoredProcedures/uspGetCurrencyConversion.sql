CREATE PROCEDURE [dbo].[uspGetCurrencyConversion]
	@FKCurrencyID	Bigint,
	@FKCompanyID	Bigint
AS
Begin
	Select 1 as Result,A.PKCurrencyID,Isnull(B.ConversionVal,0) as ConversionVal,A.FullName,A.ShortName,A.Symbol From tblCurrencyMaster A
	Left Join tblCurrencyConversion B on A.PKCurrencyID=B.FKCurrencyID And B.FKCompanyID=@FKCompanyID
	Where A.PKCurrencyID=@FKCurrencyID Or @FKCurrencyID=0
	Order By A.FullName,A.ShortName
End