CREATE PROCEDURE [dbo].[uspInsertParty]
	@PKID                BIGINT,
    @Code                VARCHAR (50),
    @Company             VARCHAR (200),
    @CPerson			 Varchar(50),
	@CPersonTitle		 Varchar(50),  
    @Address1			 Varchar(200),
	@Address2			 Varchar(200),
	@FKTahsilID			 Bigint,	
	@FKCityID			 Bigint,
	@FKStateID			 Bigint, 
	@FKCountryID		 Bigint,
	@ZIP				 Varchar(10),
    @EMailID             VARCHAR (50),
    @Phone1			     Varchar(15),
	@Phone2			     Varchar(15),
    @Mobile              VARCHAR (50),
    @Fax                 VARCHAR (50),
    @Website             VARCHAR (500),   
	@Notes               VARCHAR (500), 
	@FKCompanyID		 Bigint, 
	@FKUserID			 Bigint,	
	@FKPageID		     Bigint=0,
	@IPAddr			     Varchar(50)

AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		
		
		
	
		If(@FKTahsilID=0)
		Set @FKTahsilID=null
		If(@FKCityID=0)
		Set @FKCityID=null
		If(@FKStateID=0)
		Set @FKStateID=null
		If(@FKCountryID=0)
		Set @FKCountryID=null


		Declare @Count Bigint=0
		Declare @Operation Varchar(100)=''
		

		
		

		--Validate Login ID
		if(@Result=1)
		Begin
			Select @Count=count(*) from tblPartyMaster where PKID<>@PKID  and Code=@Code and FKCompanyID=@FKCompanyID
			If(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Vendor Code is already exists!'
			End
		End
		
		If(@Result=1)
		Begin			
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblPartyMaster','PKID',@PKID output
				Insert Into tblPartyMaster(PKID, FKCompanyID, Code, Company, CPerson, CPersonTitle, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, EMailID, Phone1, Phone2, Mobile, Fax, Website,Notes, FKCreatedBy, CreationDate)
				Values(@PKID, @FKCompanyID, @Code, @Company, @CPerson, @CPersonTitle, @Address1, @Address2, @FKTahsilID, @FKCityID, @FKStateID, @FKCountryID, @ZIP, @EMailID, @Phone1, @Phone2, @Mobile, @Fax, @Website,@Notes, @FKUserID, GETUTCDATE())				
				
				Set @Operation='New Vendor '+@Company+' Added'
			End
			Else
			Begin
				Update tblPartyMaster Set Code=@Code,Company=@Company,CPerson=@CPerson,CPersonTitle=@CPersonTitle,
				Address1=@Address1,Address2=@Address2,FKTahsilID=@FKTahsilID,FKCityID=@FKCityID,FKStateID=@FKStateID,
				FKCountryID=@FKCountryID,ZIP=@ZIP,EMailID=@EMailID,Phone1=@Phone1,Phone2=@Phone2,Mobile=@Mobile,Fax=@Fax,Website=@Website,Notes=@Notes,
				FKLastModifiedBy=@FKUserID,
				ModificationDate=GETUTCDATE()
				Where PKID=@PKID And FKCompanyID=@FKCompanyID				

				Set @Operation='Vendor  '+@Code+' Updated'
			End

		End		

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddr,@Operation,@PKID
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
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddr
			select @Result as Result,@Msg as Msg
	END CATCH
End

