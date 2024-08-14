CREATE PROCEDURE [dbo].[uspDeleteUser]
	@PKUserID	Bigint,	
	@FKUserID	Bigint,
	@FKPageID	Bigint=0,
	@IPAddress	Varchar(50)
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(max)=''
	Declare @Operation Varchar(50)=''
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
	Declare @count Bigint
	Select @count=count(*) From tblUser Where BStatus=1 and FKCreatedBy=@PKUserID
	if(@count>0)
	Begin
		Set @Result=0
		Set @Msg='Employee cannot be deleted, associated with the User Creation!'
	End
	if(@Result=1)
	Begin
		Select @count=count(*) From tblUser Where BStatus=1 and FKLastModifiedBy=@PKUserID
		if(@count>0)
		Begin
			Set @Result=0
			Set @Msg='Employee cannot be deleted, associated with the User Modification'
		End
	End
	if(@Result=1)
	Begin
		Select @count=count(*) From tblUser Where FKManagerID=@PKUserID
		if(@count>0)
		Begin
			Set @Result=0
			Set @Msg='Employee cannot be deleted, due to assigned as a manager'
		End
	End
	if(@Result=1)
	Begin
		Select @count=count(*) From tblTimeSheet Where FKEmpID=@PKUserID
		if(@count>0)
		Begin
			Set @Result=0
			Set @Msg='Employee cannot be deleted, associated with the timesheet entry'
		End
	End
	if(@Result=1)
	Begin
		Select @count=count(*) From tblExpensesLog Where FKEmpID=@PKUserID
		if(@count>0)
		Begin
			Set @Result=0
			Set @Msg='Employee cannot be deleted, associated with the expenses entry'
		End
	End
	if(@Result=1)
	Begin
		Select @count=count(*) From tblProject Where FKManagerID=@PKUserID
		if(@count>0)
		Begin
			Set @Result=0
			Set @Msg='Employee cannot be deleted, due to assigned as a project manager'
		End
	End
	if(@Result=1)
	Begin
		Select @count=count(*) From tblClient Where FKManagerID=@PKUserID
		if(@count>0)
		Begin
			Set @Result=0
			Set @Msg='Employee cannot be deleted, due to assigned as a client manager'
		End
	End
	if(@Result=1)
	Begin
		SElect @Operation=FName From tblUser Where PKUserID=@PKUserID
		Delete From tblEmpRate where FKUserID=@PKUserID
		Delete From tblUser Where PKUserID=@PKUserID
		Set @Operation='User '+@Operation+' deleted'
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKUserID
	End

	Select @Result as Result,@Msg as Msg

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION
			Declare @SPName Varchar(200)
				Set @SPName=ERROR_PROCEDURE()	
				Set @Msg='An employee cannot be deleted, due to referred on other places'
				Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddress
				select 0 as Result,@Msg as Msg
	END CATCH
End
