Create PROCEDURE [dbo].[uspInsertDesignation]
	@PKDesigID	Bigint,
	@DesigName	Varchar(50),
	@DesigDesc	Varchar(200),	
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
		
		if(@FKCompanyID=0)
		Set @FKCompanyID=NUll

		

		If(@PKDesigID=0)
		Begin
				Exec uspGetNewID 'tblDesigMaster','PKDesigID',@PKDesigID output
				Insert Into tblDesigMaster(PKDesigID, DesigName, DesigDesc, FKCompanyID,CreationDate,FKCreatedBy,ModificationDate,FKLastModifiedBy)
				Values(@PKDesigID, @DesigName, @DesigDesc, @FKCompanyID,GETUTCDATE(),@FKUserID,GETUTCDATE(),@FKUserID)
				Set @Operation='New Designation '+@DesigName+' Added'
		End
		Else
		Begin
				Update tblDesigMaster Set  DesigName=@DesigName, DesigDesc=@DesigDesc,FKLastModifiedBy=@FKUserID,ModificationDate=GETUTCDATE()
				Where PKDesigID=@PKDesigID and FKCompanyID=@FKCompanyID
				Set @Operation='Designation '+@DesigName+' Updated'
		End

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKDesigID
	End
		
	Select @Result as Result,@Msg as Msg

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		
		ROLLBACK TRANSACTION
			
			if(@ErrorCount<1)
			Begin
				Set @ErrorCount=@ErrorCount+1
				Goto AddTran
			End
			Else
			Begin
				Set @Result=0
				Set @Msg = ERROR_MESSAGE()	
				Declare @SPName Varchar(200)
				Set @SPName=ERROR_PROCEDURE()	
				Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddress
				select @Result as Result,@Msg as Msg
			End
	END CATCH
End
