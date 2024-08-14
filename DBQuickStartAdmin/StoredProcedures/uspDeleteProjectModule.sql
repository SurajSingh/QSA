CREATE PROCEDURE [dbo].[uspDeleteProjectModule]
	@PKID	Bigint,	
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
	Select @count=count(*) From tblProjectModule Where  PKID=@PKID and FKCompanyID=@FKCompanyID
	if(@count=0)
	Begin
		Set @Result=0
		Set @Msg='Invalid Operation'
	End

	IF(@Result=1)
	Begin
	Select @count=count(*) From tblProjectModule Where FKParentID=@PKID and FKCompanyID=@FKCompanyID
		if(@count>0)
		Begin
			Set @Result=0
			Set @Msg='Unable delete project module. Associated with the sub module'
		End

	End
	
	if(@Result=1)
	Begin
		SElect @Operation=ModuleName From tblProjectModule Where PKID=@PKID
		Delete From tblProjectModule Where  PKID=@PKID
		Set @Operation='Project Module '+@Operation+' deleted'
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

