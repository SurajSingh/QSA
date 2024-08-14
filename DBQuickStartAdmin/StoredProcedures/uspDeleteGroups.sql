CREATE PROCEDURE [dbo].[uspDeleteGroups]
	@PKID	Bigint,	
	@RecType	Varchar(50),
	@FKCompanyID	Bigint,	
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
	
	If(@RecType='Employee')
	Begin
			Select @count=count(*) From tblEmpGroup Where PKID=@PKID and FKCompanyID=@FKCompanyID
			if(@count=0)
			Begin
				Set @Result=0
				Set @Msg='Invalid Operation'
			End

			If(@Result=1)
			Begin
				SElect @Operation=GroupName From tblEmpGroup Where PKID=@PKID
				Delete From tblEmpGroupDetail Where  FKID=@PKID
				Delete From tblEmpGroup Where  PKID=@PKID
				Set @Operation='Employee Group '+@Operation+' deleted'
			End

	End
	Else If(@RecType='Client')
	Begin
			Select @count=count(*) From tblClientGroup Where PKID=@PKID and FKCompanyID=@FKCompanyID
			if(@count=0)
			Begin
				Set @Result=0
				Set @Msg='Invalid Operation'
			End

			If(@Result=1)
			Begin
				SElect @Operation=GroupName From tblClientGroup Where PKID=@PKID
				Delete From tblClientGroupDetail Where  FKID=@PKID
				Delete From tblClientGroup Where  PKID=@PKID
				Set @Operation='Client Group '+@Operation+' deleted'
			End
	End
	Else If(@RecType='Project')
	Begin
				Select @count=count(*) From tblProjectGroup Where PKID=@PKID and FKCompanyID=@FKCompanyID
			if(@count=0)
			Begin
				Set @Result=0
				Set @Msg='Invalid Operation'
			End

			If(@Result=1)
			Begin
				SElect @Operation=GroupName From tblProjectGroup Where PKID=@PKID
				Delete From tblProjectGroupDetail Where  FKID=@PKID
				Delete From tblProjectGroup Where  PKID=@PKID
				Set @Operation='Project Group '+@Operation+' deleted'
			End

	End
	Else If(@RecType='Expenses')
	Begin
			Select @count=count(*) From tblExpenseGroup Where PKID=@PKID and FKCompanyID=@FKCompanyID
			if(@count=0)
			Begin
				Set @Result=0
				Set @Msg='Invalid Operation'
			End

			If(@Result=1)
			Begin
				SElect @Operation=GroupName From tblExpenseGroup Where PKID=@PKID
				Delete From tblExpenseGroupDetail Where  FKID=@PKID
				Delete From tblExpenseGroup Where  PKID=@PKID
				Set @Operation='Expense Group '+@Operation+' deleted'
			End


	End
	

	if(@Result=1)
	Begin
		
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKID
	End

	Select @Result as Result,@Msg as Msg

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION
			Set @ErrorCount=@ErrorCount+1
			Set @Result=0
			Set @Msg = ERROR_MESSAGE()
			Declare @SPName Varchar(200)
			Set @SPName=ERROR_PROCEDURE()	
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName			
			select @Result as Result,@Msg as Msg
	END CATCH
End
