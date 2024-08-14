CREATE PROCEDURE [dbo].[uspInsertTaskMaster]
@PKID			Bigint,
@TaskCode		VARCHAR (50),
@TaskName		VARCHAR (100),
@Description	VARCHAR (500),
@IsBillable		BIT,
@ActiveStatus	VARCHAR (50),
@FKDeptID		Bigint, 
@CostRate		DECIMAL (18, 4),
@BillRate		DECIMAL (18, 4),
@TEType			VARCHAR (50),
@Tax			DECIMAL (18, 4),
@BHours			DECIMAL (18, 4),
@isReimb		BIT,
@MuRate			DECIMAL (18, 4), 
@FKCompanyID	Bigint, 
@FKUserID		Bigint,	
@FKPageID		Bigint=0,
@IPAddr			Varchar(50)

AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		
		
		
		if(@FKDeptID=0)
		set @FKDeptID=null
		
		Declare @Count Bigint=0
		Declare @Operation Varchar(100)=''
		

		
		

		--Validate Login ID
		if(@Result=1)
		Begin
			Select @Count=count(*) from tblTask where PKID<>@PKID and BStatus=1 and TaskCode+TaskName=@TaskCode+@TaskName
			If(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Task Code with Task Name is already exists!'
			End
		End
		
		If(@Result=1)
		Begin			
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblTask','PKID',@PKID output
				Insert Into tblTask(PKID, TaskCode, TaskName, Description, IsBillable, ActiveStatus, FKDeptID, CostRate, BillRate, TEType, Tax, BHours, isReimb, MuRate, FKCompanyID, FKCreatedBy, FKLastModifiedBy, CreationDate, ModificationDate, BStatus)
				Values(@PKID, @TaskCode, @TaskName, @Description, @IsBillable, @ActiveStatus, @FKDeptID, @CostRate, @BillRate, @TEType, @Tax, @BHours, @isReimb, @MuRate, @FKCompanyID, @FKUserID, null, GETUTCDATE(), null, 1)				
				
				Set @Operation='New Task '+@TaskName+':'+@TaskCode+' Added'
			End
			Else
			Begin
				Update tblTask Set TaskCode=@TaskCode,TaskName=@TaskName,Description=@Description,IsBillable=@IsBillable,ActiveStatus=@ActiveStatus,FKDeptID=@FKDeptID,CostRate=@CostRate,BillRate=@BillRate,TEType=@TEType,Tax=@Tax,BHours=@BHours,isReimb=@isReimb,MuRate=@MuRate,FKLastModifiedBy=@FKUserID,ModificationDate=GETUTCDATE()
				Where PKID=@PKID And FKCompanyID=@FKCompanyID				

				Set @Operation='Task  '+@TaskName+':'+@TaskCode+' Updated'
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
