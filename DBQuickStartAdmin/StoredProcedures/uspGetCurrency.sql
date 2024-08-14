CREATE PROCEDURE [dbo].[uspGetCurrency]
	
AS
Begin
	Select PKCurrencyID, Symbol, ShortName, FullName From tblCurrencyMaster
End
