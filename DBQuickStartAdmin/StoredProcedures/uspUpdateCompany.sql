CREATE PROCEDURE [dbo].[uspUpdateCompany]
	@PKCompanyID		Bigint,
	@CompanyID			Varchar(50),
	@CompanyName		Varchar(50),
	@Address1			Varchar(200),
	@Address2			Varchar(200),
	@FKTahsilID			Bigint,	
	@FKCityID			Bigint,
	@FKStateID			Bigint,
	@FKCountryID		Bigint,
	@ZIP				Varchar(10),
	@Mobile				Varchar(15),
	@Phone				Varchar(15),
	@Email				Varchar(50),
	@CPerson			Varchar(50),
	@CPersonTitle		Varchar(50),
	@GSTNo				Varchar(20),
	@PANNo				Varchar(20),
	@LogoURL			Varchar(50),
	@Website			Varchar(200),	
	@FKTimezoneID		Bigint,
	@FKCurrencyID		Bigint,
	@DateForStr			Varchar(50)
	
	
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Count Bigint=0
	Declare @Operation Varchar(50)
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
	Declare @CurrencySymbol		NVarchar(5)

	Select @CurrencySymbol=Symbol From tblCurrencyMaster Where PKCurrencyID=@FKCurrencyID

	If(@FKCountryID=0)
	Set @FKCurrencyID=null

	If(@FKStateID=0)
	Set @FKStateID=null

	If(@FKCityID=0)
	Set @FKCityID=null

	If(@FKTahsilID=0)
	Set @FKTahsilID=null

	Update tblCompany Set CompanyName=@CompanyName, Address1=@Address1, Address2=@Address2, 
	FKTahsilID=@FKTahsilID, FKCityID=@FKCityID, FKStateID=@FKStateID, FKCountryID=@FKCountryID, ZIP=@ZIP, 
	Mobile=@Mobile, Phone=@Phone, Email=@Email, CPerson=@CPerson, CPersonTitle=@CPersonTitle, GSTNo=@GSTNo, 
	PANNo=@PANNo, LogoURL=@LogoURL,Website=@Website,FKTimezoneID=@FKTimezoneID, FKCurrencyID=@FKCurrencyID, CurrencySymbol=@CurrencySymbol,
	DateForStr=@DateForStr, ModificationDate=GETUTCDATE()
	where PKCompanyID=@PKCompanyID
	Select @Result as Result,@Msg as Msg,@CurrencySymbol as CurrencySymbol	
		
	COMMIT TRANSACTION		
	END TRY
	BEGIN CATCH
		
		ROLLBACK TRANSACTION
			
			Set @Result=0
				Set @Msg = ERROR_MESSAGE()	
				Declare @SPName Varchar(200)
				Set @SPName=ERROR_PROCEDURE()	
				Exec sp_InsertErrorLog 0,'SP',@SPName,@Msg,''
				select @Result as Result,@Msg as Msg,ERROR_LINE()
	END CATCH
End
