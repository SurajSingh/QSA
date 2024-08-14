CREATE PROCEDURE [dbo].[uspGetTaxMaster]
@PageSize			bigint=0,
@PageNo				Bigint=0,
@SortBy				Varchar(200),
@SortDir			Varchar(50),
@PKID			Bigint,
@TaxName		Varchar(50),
@FKCompanyID	Bigint
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	
	Set @StrQry=N' Select RCount = COUNT(*) OVER(),1 as Result,PKID,TaxName,TaxPercentage
	From tblTaxMaster Where FKCompanyID=@FKCompanyID
	And (PKID=@PKID Or @PKID=0)
	Order By TaxName'
	
	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@PKID	Bigint,@TaxName Varchar(50),@FKCompanyID Bigint'	
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@PKID,@TaxName,@FKCompanyID

End

