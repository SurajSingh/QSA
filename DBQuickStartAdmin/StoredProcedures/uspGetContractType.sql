CREATE PROCEDURE [dbo].[uspGetContractType]
	
AS
Begin
	Select PKID,ContractType From tblContractType Order by PKID
End