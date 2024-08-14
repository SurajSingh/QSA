CREATE PROCEDURE [dbo].[uspApproveLeaveRequest]
	@PKID	Bigint,	
	@ApproveStatus	Varchar(50),
	@Remarks	Varchar(500),
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
	Declare @FKApproveByID Bigint
	Declare @PApproveStatus Varchar(50)
	Select @count=count(*) From tblLeaveRequest Where PKID=@PKID and FKCompanyID=@FKCompanyID
	if(@count=0)
	Begin
		Set @Result=0
		Set @Msg='Invalid Operation'
	End
	If(@Result=1)
	Begin
		Select @FKApproveByID=FKApproveBy,@PApproveStatus=ApproveStatus From tblLeaveRequest Where PKID=@PKID
		If(@PApproveStatus='Approved')
		Begin
			Set @Result=0
			Set @Msg='Request status is already approved'
		End
		else If(@PApproveStatus='Rejected')
		Begin
			Set @Result=0
			Set @Msg='Request status is already rejected'
		End

	End


	if(@Result=1)
	Begin
		
		Update tblLeaveRequest Set ApproveStatus=@ApproveStatus,FKApproveBy=@FKUserID,RejectReason=@Remarks Where  PKID=@PKID
		Set @Operation='Leave request approved'
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

