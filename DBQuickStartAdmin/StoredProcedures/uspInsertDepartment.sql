CREATE PROCEDURE [dbo].[uspInsertDepartment]
	@PKDeptID	Bigint,
	@DeptName	Varchar(50),
	@DeptDesc	Varchar(200),	
	@FKManagerID	Bigint,
	@FKCompanyID	Bigint,
	@FKUserID	Bigint,
	@FKPageID	Bigint=0,
	@IPAddress	Varchar(50)
	
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Operation Varchar(50)
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		Declare @Count Bigint
		
		Select @Count=Count(*) From tblDeptMaster where DeptName=@DeptName And FKCompanyID=@FKCompanyID And (PKDeptID<>@PKDeptID)
		
		If(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Department Already Exists'
		End

	If(@Result=1)
	Begin
		If(@FKManagerID=0)
		Set @FKManagerID=Null

		If(@PKDeptID=0)
		Begin
				Exec uspGetNewID 'tblDeptMaster','PKDeptID',@PKDeptID output
				Insert Into tblDeptMaster(PKDeptID, DeptName, DeptDesc,FKCompanyID,CreationDate,ModificationDate,FKManagerID)
				Values(@PKDeptID, @DeptName, @DeptDesc,  @FKCompanyID,GETUTCDATE(),null,@FKManagerID)
				Set @Operation='New Department '+@DeptName+' Added'
		End
		Else
		Begin
				Update tblDeptMaster Set  DeptName=@DeptName, DeptDesc=@DeptDesc, FKManagerID=@FKManagerID,ModificationDate=GETUTCDATE()
				Where PKDeptID=@PKDeptID
				Set @Operation='Department '+@DeptName+' Updated'
		End
	End

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKDeptID
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
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddress
			select @Result as Result,@Msg as Msg
	END CATCH
End
