CREATE PROCEDURE [dbo].[uspInsertUser]
	@PKUserID			Bigint=0,
	@LoginID			Varchar(50),	
	@EmailID			Varchar(50),
	@PWD				Varchar(200),
	@FName				Varchar(50),
	@MName				Varchar(50)	,
	@LName				Varchar(50),
	@EnrollNo			Varchar(50)	, 
	@DOB				Date,
	@Gender				Varchar(50),
	@MobNo				Varchar(15),	
	@Phone1				Varchar(15),
	@Phone2				Varchar(15),
	@AddressTitle		Varchar(200),
	@Address1			Varchar(200),
	@Address2			Varchar(200),
	@FKTahsilID			Bigint,	
	@FKCityID			Bigint,
	@FKStateID			Bigint, 
	@FKCountryID		Bigint,
	@ZIP				Varchar(10),
	@JoinDate			Date,
	@ReleasedDate		Date,
	@FKManagerID		Bigint,
	@FKSubmitToID		Bigint,
	@OrgTypeID			Varchar(2),
	@RoleType			Varchar(20),
	@FKRoleGroupID		Bigint,	
	@FKCompanyID		Bigint,
	@FKDeptID			Bigint,	
	@FKDesigID			Bigint,	
	@FKTimezoneID		Bigint, 
	@Remark			    NVarchar(500),
	@IsAppointment	    Bit ,	
	@IsDefaultUser		Bit,	
	@FKDashboardID		Bigint,
	@ActiveStatus		Varchar(50),
	@BillRate           DECIMAL (18, 2),
    @PayRate            DECIMAL (18, 2),
    @OverTimeBillRate   DECIMAL (18, 2),
    @OverTimePayrate    DECIMAL (18, 2),
    @OverheadMulti      DECIMAL (18, 2),
    @FKCurrencyID		Bigint, 
    @PayPeriod          VARCHAR (50),
    @SalaryAmount       DECIMAL (18, 2),  
	@FKUserID			Bigint,	
	@IPAddr				Varchar(50),
	@MACAddr			Varchar(50),
	@FKPageID			Bigint=0

	
	
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		
		

		if(@FKCompanyID=0)
		set @FKCompanyID=null
		if(@FKDeptID=0)
		set @FKDeptID=null
		if(@FKDesigID=0)
		Set @FKDesigID=null
		if(@FKRoleGroupID=0)
		Set @FKRoleGroupID=null
		If(@FKDashboardID=0)
		Set @FKDashboardID=null

		If(@FKTahsilID=0)
		Set @FKTahsilID=null
		If(@FKCityID=0)
		Set @FKCityID=null
		If(@FKStateID=0)
		Set @FKStateID=null
		If(@FKCountryID=0)
		Set @FKCountryID=null

		If(@FKManagerID=0)
		Set @FKManagerID=null

		If(@FKSubmitToID=0)
		Set @FKSubmitToID=null

		If(@FKCurrencyID=0)
		Set @FKCurrencyID=null

		If(@FKTimezoneID=0)
		Set @FKTimezoneID=null

		Declare @Count Bigint=0
		Declare @Operation Varchar(100)=''
		Declare @SNo Bigint=0
		--Check Email ID
		Select @Count=count(*) from tblUser where PKUserID<>@PKUserID and BStatus=1 and EmailID=@EmailID
		If(@Count>0 and @EmailID<>'')
		Begin
			Set @Result=0
			Set @Msg='Email ID is already registered!'
		End

		--Check Mobile No
		if(@Result=1 and @MobNo<>'')
		Begin
			Select @Count=count(*) from tblUser where PKUserID<>@PKUserID and BStatus=1 and MobNo=@MobNo
			If(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Mobile No. is already registered!'
			End
		End
		
		

		--Validate Login ID
		if(@Result=1)
		Begin
			Select @Count=count(*) from tblUser where PKUserID<>@PKUserID and BStatus=1 and LoginID=@LoginID
			If(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Login ID is already registered!'
			End
		End
		
		If(@Result=1)
		Begin
			
			If(@PKUserID=0)
			Begin
				 
				Exec uspGetNewID 'tblUser','PKUserID',@PKUserID output
				Select @SNo=Isnull(max(SNo),0) FRom tblUser where FKCompanyID=@FKCompanyID
				Set @SNo=@SNo+1
				Set @EnrollNo=RIGHT(CONCAT('0000', @SNo), 4)


				Insert Into tblUser(PKUserID, LoginID,SNo, EmailID, PWD, FName, MName, LName, DOB, Gender, MobNo, Phone1, Phone2, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, JoinDate, ReleasedDate, FKManagerID, FKSubmitToID, OrgTypeID, RoleType, FKRoleGroupID, FKCompanyID, FKDeptID, FKDesigID, FKTimezoneID, IsDefaultUser, PhotoURL, FKDashboardID, ActiveStatus, FKCreatedBy, CreationDate, UserToken, EnrollNo, AddressTitle, Remark, IsAppointment)
				Values(@PKUserID, @LoginID,@SNo, @EmailID, @PWD, @FName, @MName, @LName, @DOB, @Gender, @MobNo, @Phone1, @Phone2, @Address1, @Address2, @FKTahsilID, @FKCityID, @FKStateID, @FKCountryID, @ZIP, @JoinDate, @ReleasedDate, @FKManagerID, @FKSubmitToID, @OrgTypeID, @RoleType, @FKRoleGroupID, @FKCompanyID, @FKDeptID, @FKDesigID, @FKTimezoneID, @IsDefaultUser, '', @FKDashboardID, @ActiveStatus, @FKUserID, GETUTCDATE(), '', @EnrollNo, @AddressTitle, @Remark, @IsAppointment)				
				Set @Operation='New User '+@FName+' Added'
			End
			Else
			Begin
				Update tblUser Set LoginID=@LoginID,EmailID=@EmailID,PWD=@PWD,FName=@FName,MName=@MName,LName=@LName,DOB=@DOB,Gender=@Gender,MobNo=@MobNo,Phone1=@Phone1,Phone2=@Phone2,Address1=@Address1,Address2=@Address2,FKTahsilID=@FKTahsilID,FKCityID=@FKCityID,FKStateID=@FKStateID,FKCountryID=@FKCountryID,ZIP=@ZIP,JoinDate=@JoinDate,ReleasedDate=@ReleasedDate,FKManagerID=@FKManagerID,FKSubmitToID=@FKSubmitToID,OrgTypeID=@OrgTypeID,RoleType=@RoleType,FKRoleGroupID=@FKRoleGroupID,FKCompanyID=@FKCompanyID,FKDeptID=@FKDeptID,FKDesigID=@FKDesigID,FKTimezoneID=@FKTimezoneID,FKDashboardID=@FKDashboardID,ActiveStatus=@ActiveStatus,FKLastModifiedBy=@FKUserID,ModificationDate=GETUTCDATE(),
				AddressTitle=@AddressTitle,Remark=@Remark,
				IsAppointment=@IsAppointment
				Where PKUserID=@PKUserID And FKCompanyID=@FKCompanyID
				

				Set @Operation='User '+@FName+' Updated'
			End
			
			select @Count=count(*) from tblEmpRate where FKUserID=@PKUserID
			IF(@Count>0)
			Begin
				Update tblEmpRate Set BillRate=@BillRate, PayRate=@PayRate, OverTimeBillRate=@OverTimeBillRate, OverTimePayrate=@OverTimePayrate, 
				OverheadMulti=@OverheadMulti, FKCurrencyID=@FKCurrencyID, PayPeriod=@PayPeriod, SalaryAmount=@SalaryAmount
				Where FKUserID=@PKUserID
			End
			Else
			Begin
				Insert Into tblEmpRate(FKUserID, BillRate, PayRate, OverTimeBillRate, OverTimePayrate, OverheadMulti, FKCurrencyID, PayPeriod, SalaryAmount)
				Values(@PKUserID, @BillRate, @PayRate, @OverTimeBillRate, @OverTimePayrate, @OverheadMulti, @FKCurrencyID, @PayPeriod, @SalaryAmount)
			End


		End		

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddr,@Operation,@PKUserID
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


