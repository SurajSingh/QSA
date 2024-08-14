CREATE PROCEDURE [dbo].[uspInsertLeaveRequest]
	@PKID	        Bigint,	
	@FromDate		Date,
	@ToDate			Date,
	@FKEmpID		Bigint, 
	@FKLeaveID		Bigint, 
	@LeaveCount		Decimal(18,2),	
	@Remarks				Varchar(500),
	@ApproveStatus	Varchar(50),
	@FKApproveBy	Bigint, 
	@FKCompanyID	Bigint,
	@FKUserID	    Bigint,
	@FKPageID	    Bigint=0,
	@IPAddress	    Varchar(50)
	
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

	Select @Count=Count(*) from tblLeaveRequest where FKEmpID=@FKEmpID And (ApproveStatus='Pending' Or ApproveStatus='Approve')
	And  (FromDate<=@FromDate and ToDate>=@ToDate) or ( ToDate>=@ToDate and FromDate<=@ToDate) or (FromDate>@FromDate and ToDate<@ToDate)

	If(@Count>0)
	Begin
		Set @Result=0
		Set @Msg='Leave request already exists between selected date interval'
	End

		
	If(@Result=1)
	Begin
		
		If(@FKApproveBy=0)
		Begin
			Set @FKApproveBy=Null
		End
		If(@PKID=0)
		Begin
				Exec uspGetNewID 'tblLeaveRequest','PKID',@PKID output
				Insert Into tblLeaveRequest(PKID, FromDate, ToDate, FKEmpID, FKLeaveID, LeaveCount,Remarks, FKCompanyID, ApproveStatus, FKApproveBy, FKCreatedBy, FKLastModifiedBy, CreationDate, ModificationDate)
				Values(@PKID, @FromDate, @ToDate, @FKEmpID, @FKLeaveID, @LeaveCount,@Remarks, @FKCompanyID, @ApproveStatus, @FKApproveBy, @FKUserID, null, GETUTCDATE(), GETUTCDATE())
				Set @Operation='New Leave Request Added'
		End
		Else
		Begin
				Update tblLeaveRequest Set  FromDate=@FromDate, ToDate=@ToDate, FKEmpID=@FKEmpID, FKLeaveID=@FKLeaveID, LeaveCount=@LeaveCount,Remarks=@Remarks, 
				FKLastModifiedBy=@FKUserID, ModificationDate=GETUTCDATE()
				Where PKID=@PKID
				Set @Operation='Leave Request Updated'
		End
	End

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKID
	End
		
	Select @Result as Result,@Msg as Msg,@PKID as PKID

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


