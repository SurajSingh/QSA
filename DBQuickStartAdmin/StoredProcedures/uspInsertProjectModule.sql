CREATE PROCEDURE [dbo].[uspInsertProjectModule]
	@PKID				Bigint ,
	@FKProjectID		Bigint,	
	@ModuleName			NVarchar(500),
	@ModuleDesc			NVarchar(max),
	@FKParentID			Bigint, 
	@FKTaskID			Bigint,
	@EstStartDate		Date,
	@EstEndDate			Date,
	@EstHrs				Bigint,
	@CompletePer		Decimal(18,2),	
	@TaskStatus			Varchar(50),
	@RecType			Varchar(50),
	@FKCompanyID		Bigint,
	@FKUserID			Bigint,
	@FKPageID			Bigint=0,
	@IPAddress			Varchar(50)
AS
Begin
	Declare @Result Bigint=1
	DEclare @Msg Varchar(500)=''
	Declare @Count Bigint
	Declare @SNo Bigint=0
	Declare @DownLine Varchar(max)=''
	
	If(@RecType='Task')
	Begin
		Select @Count=Count(*) from tblProjectModule where FKParentID=@FKParentID And RecType='Module' and PKID<>@PKID

		If(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Unable to add activity under this module due to sub module existance'
		End
	End
	Else
	Begin
		Select @Count=Count(*) from tblProjectModule where FKParentID=@FKParentID And RecType='Task' and PKID<>@PKID

		If(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Unable to add sub module under this module due to activity existance'
		End

	End

	If(@Result=1)
	Begin
		IF(@RecType='Task')
		Begin
			IF(@EstStartDate is not null and @EstEndDate is not Null)
			Begin
				If(@EstStartDate>@EstEndDate)
				Begin
					Set @Result=0
					Set @Msg='Est. Start Date is greater then the Est. End Date'
				End
			End
		End
	End

	If(@Result=1)
	Begin
		If(@PKID=0)
		Begin
			Select @SNo=max(SNo) from tblProjectModule where FKProjectID=@FKProjectID
			Set @SNo=Isnull(@SNo,0)+1

			If(@FKParentID<>0)
			Begin
				Select @DownLine=Downline From tblProjectModule where PKID=@FKParentID
				Set @DownLine=@DownLine+'-'+CONVERT(Varchar(50),@SNo)
			End
			Else
			Begin
				Set @FKParentID=Null
				Set @DownLine=@SNo
			End

			If(@FKTaskID=0)
			Begin
				Set @FKTaskID=Null
			End
			Exec uspGetNewID 'tblProjectModule','PKID',@PKID output
			Insert Into tblProjectModule(PKID,FKProjectID,SNo,DownLine,ModuleName,ModuleDesc,FKParentID,FKTaskID, EstStartDate, EstEndDate, EstHrs, CompletePer, TaskStatus, RecType,FKCompanyID,FKCreatedBy,CreationDate) 
			Values(@PKID,@FKProjectID,@SNo,@DownLine,@ModuleName,@ModuleDesc,@FKParentID,@FKTaskID, @EstStartDate, @EstEndDate, @EstHrs, @CompletePer, @TaskStatus, @RecType,@FKCompanyID,@FKUserID,GETUTCDATE())

		End
		Else
		Begin
			Update tblProjectModule Set ModuleName=@ModuleName,ModuleDesc=@ModuleDesc,
			FKTaskID=@FKTaskID, EstStartDate=@EstStartDate, EstEndDate=@EstEndDate, EstHrs=@EstHrs, CompletePer=@CompletePer, TaskStatus=@TaskStatus,
			FKLastModifiedBy=@FKUserID,ModificationDate=GETUTCDATE()
			Where PKID=@PKID

		End


	End

	Select @Result as Result, @Msg as Msg

End
