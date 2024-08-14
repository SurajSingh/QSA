CREATE PROCEDURE [dbo].[uspApproveInvoice]
	@PKID					Bigint,	
	@FKUserID				Bigint,	
	@Action					Varchar(50),
	@ApproveRemark			Varchar(500),
	@FKCompanyID			Bigint

AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Count Bigint=0
	Declare @Operation Varchar(50)	
	
	Declare @fkSubmittoID Bigint

	BEGIN TRANSACTION
	BEGIN TRY	

	If(@PKID<>0)
	Begin
	Set @fkSubmittoID = select I.FKSubmitToID from tblInvoice where I.PKID = @PKID;
	
		If(@fkSubmittoID == @FKUserID)
		Begin
			Update I Set I.ApprovedStatus=@Action,I.FKApprovedByID=@FKUserID,I.ApprovedDate=GETUTCDATE(),I.ApprovedRemark=@ApproveRemark
				From tblInvoice I
				Where I.PKID=@PKID
		End
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
				Exec sp_InsertErrorLog 0,'SP',@SPName,@Msg,''
				select @Result as Result,@Msg as Msg,ERROR_LINE() as [LineNo],@SPName as SPName
	END CATCH
End


