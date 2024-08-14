CREATE PROCEDURE [dbo].[uspDeleteDepartment]
	@PKDeptID	Bigint,	
	@FKUserID	Bigint,
	@FKPageID	Bigint=0,
	@IPAddress	Varchar(50)
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Operation Varchar(50)=''
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
	Declare @count Bigint
	Select @count=count(*) From tblUser Where BStatus=1 and FKDeptID=@PKDeptID
	if(@count>0)
	Begin
		Set @Result=0
		Set @Msg='Department associated with the User!'
	End
	if(@Result=1)
	Begin
		SElect @Operation=DeptName From tblDeptMaster Where PKDeptID=@PKDeptID
		Delete From tblDeptMaster Where PKDeptID=@PKDeptID
		Set @Operation='Department '+@Operation+' deleted'
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKDeptID
	End

	Select @Result as Result,@Msg as Msg

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION
			
			Declare @SPName Varchar(200)
			Set @SPName=ERROR_PROCEDURE()	
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddress
			select @Result as Result,@Msg as Msg
	END CATCH
End
