Create PROCEDURE [dbo].[uspCreateNewCompany]
	@PKCompanyID		Bigint=0,
	@RegDate			Date='01/01/2022',	
	@CompanyID			Varchar(50)='HCLLP',
	@CompanyName		Varchar(50)='My Company Name',
	@Address1			Varchar(200)='16870 W. Bernardo Dr., Ste 250',
	@Address2			Varchar(200)='',	
	@FKTahsilID			Bigint=null,	
	@FKCityID			Bigint=null,
	@FKStateID			Bigint=null,
	@FKCountryID		Bigint=2,
	@ZIP				Varchar(10)='',
	@Mobile				Varchar(15)='858-939-0017',
	@Phone				Varchar(15)='858-964-3754',
	@Email				Varchar(50)='test@quickstartadmin.com',
	@Fax				Varchar(50)='858-964-3754',
	@CPerson			Varchar(50)='Test Name',
	@CPersonTitle		Varchar(50)='',
	@GSTNo				Varchar(20)='',
	@PANNo				Varchar(20)='',
	@LogoURL			Varchar(50)='',
	@SmallLogoURL		Varchar(50)='',
	@Website			Varchar(200)='',
	@SystemURL			Varchar(200)='',	
	@FKTimezoneID		Bigint=9,
	@FKCurrencyID		Bigint=2,
	@CurrencySymbol		NVarchar(5)='$',
	@DateForStr			Varchar(50)='MM/dd/yyyy',
	@AdminURL			Varchar(200)='',		
	@PKUserID			Bigint=0,
	@UserName				Varchar(50)='Administrator',		
	@LoginID				Varchar(50)='admin',
	@PWD					Varchar(50)='rKLfwIEoQA5A+e9NdaGgAA==',
	@UserEmail				Varchar(50)='info@quickstartadmin.com',
	@UserCell				Varchar(50)='858-939-0017'
	
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
		Declare @SNo Bigint
		Select @count=count(PKCompanyID) From tblCompany 
		Where CompanyID=@CompanyID and PKCompanyID<>@PKCompanyID
		if(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Company ID is already registerd!'
		End

		
		if(@Result=1)
		Begin
			Select @count=count(PKUserID) From tblUser Where LoginID=@LoginID and PKUserID<>@PKUserID
			if(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Default Login ID already associated with an user!'
			End
		End
		
		if(@Result=1)
		Begin			
			
			if(@FKCountryID=0)
			Begin
				Set @FKCountryID=null
			End
			if(@FKStateID=0)
			Begin
				Set @FKStateID=null
			End
			if(@FKCityID=0)
			Begin
				Set @FKCityID=null
			End
			if(@FKTahsilID=0)
			Begin
				Set @FKTahsilID=null
			End
			
		
			If(@PKCompanyID=0)
			Begin
				Exec uspGetNewID 'tblCompany','PKCompanyID',@PKCompanyID output
				
				Insert into tblCompany(PKCompanyID, CompanyID, CompanyName, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, Mobile, Phone, Email, Fax, CPerson, CPersonTitle, GSTNo, PANNo, LogoURL, SmallLogoURL, Website, SystemURL, RegDate, FKTimezoneID, FKCurrencyID, CurrencySymbol, DateForStr, AdminURL, CreationDate)
				Values(@PKCompanyID, @CompanyID, @CompanyName, @Address1, @Address2, @FKTahsilID, @FKCityID, @FKStateID, @FKCountryID, @ZIP, @Mobile, @Phone, @Email, @Fax, @CPerson, @CPersonTitle, @GSTNo, @PANNo, @LogoURL, @SmallLogoURL, @Website, @SystemURL, @RegDate, @FKTimezoneID, @FKCurrencyID, @CurrencySymbol, @DateForStr, @AdminURL, GETUTCDATE())

				Insert Into tblCompanyPages(FKPageID,FKCompanyID)
				Select PKPageID,@PKCompanyID From tblPageMaster
				Where BStatus=1



				Exec uspGetNewID 'tblUser','PKUserID',@PKUserID output
				Insert into tblUser(PKUserID, LoginID, EmailID, PWD, FName, MName, LName, DOB, Gender, MobNo, Phone1, Phone2, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, JoinDate, ReleasedDate, FKManagerID, FKSubmitToID, OrgTypeID, RoleType, FKRoleGroupID, FKCompanyID, FKDeptID, FKDesigID, FKTimezoneID, IsDefaultUser, PhotoURL, FKDashboardID, ActiveStatus, FKCreatedBy, FKLastModifiedBy, CreationDate, ModificationDate, UserToken, LastLoginDate, BStatus)
				Values(@PKUserID, @LoginID, @Email, @PWD, @UserName, '', '', null, 'Male', @Mobile, @Phone, '', @Address1, @Address2, @FKTahsilID, @FKCityID, @FKStateID, @FKCountryID, @ZIP, GETDATE(), null, null, null, 'C', 'Admin', null, @PKCompanyID, null, null, @FKTimezoneID, 1, '', null, 'Active', null, null, GETUTCDATE(), null, '', null, 1)

				Declare @PKWorkTypeID	Bigint=0
				Exec uspGetNewID 'tblWorkTypeMaster','PKID',@PKWorkTypeID output
				Insert Into tblWorkTypeMaster(PKID,WorkType,FKCompanyID) Values(@PKWorkTypeID,'Office Work',@PKCompanyID)
				Insert Into tblWorkTypeMaster(PKID,WorkType,FKCompanyID) Values(@PKWorkTypeID+1,'Field Work',@PKCompanyID)


				Declare @PKFinancialYear Bigint
				Exec uspGetNewID 'tblFiscalYear','PKID',@PKFinancialYear output
				Declare @Month Bigint
				Declare @Year Bigint
				Declare @StartDate Varchar(50)
				Declare @EndDate Varchar(50)
				Select @Month=MONTH(getdate())
				Select @Year=YEAR(GETDATE())	
				
				Set @StartDate=CONVERT(Varchar(50),@Year)+'-01-01'
				Set @EndDate=CONVERT(Varchar(50),@Year)+'-12-31'

				Insert Into tblFiscalYear(PKID,FromDate,ToDate,FKCompanyID,IsActive) Values(@PKFinancialYear,@StartDate,@EndDate,@PKCompanyID,1)


			End
			
		End
	
	Select @Result as Result,@Msg as Msg	
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
