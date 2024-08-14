CREATE PROCEDURE [dbo].[uspDeleteInvoice]
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
	Declare @FKPClientID Bigint
	Declare @PNetAmount Decimal(18,4)
	Declare @PRetainage Decimal(18,4)
	Select @count=count(*) From tblInvoice Where PKID=@PKID and FKCompanyID=@FKCompanyID
	if(@count=0)
	Begin
		Set @Result=0
		Set @Msg='Invalid Operation'
	End

	--If(@Result=1)
	--Begin
	--	Select @count=count(*) From tblProject Where BStatus=1 and FKClientID=@PKID and FKCompanyID=@FKCompanyID
	--	if(@count=0)
	--	Begin
	--		Set @Result=0
	--		Set @Msg='Unable to Delete Client. Project Exists!'
	--	End
	--End

	if(@Result=1)
	Begin
		SElect @Operation=InvoiceID From tblInvoice Where PKID=@PKID
		
		--Commented by Nilesh For Task Delete invoice but not PERMANENT
		--Update tblTimeSheet Set IsBilled=0,FKInvoiceID=Null where FKInvoiceID=@PKID
		
		Select @PNetAmount=A.NetAmount,@FKPClientID=P.FKClientID,@PRetainage=Retainage From tblInvoice A Inner Join tblProject P on A.FKProjectID=P.PKID				
		where A.PKID=@PKID And A.IsDeleted=0

		Update tblClient Set TotalDr=TotalDr-@PNetAmount,Retainer=Retainer+@PRetainage where PKID=@FKPClientID
		Delete From tblTransaction Where FKInvoiceID=@PKID and TranType='Invoice'


		--Delete From tblInvoiceDetail where FKID=@PKID --Commented by Nilesh

		--Delete From tblInvoice Where  PKID=@PKID --Commented by Nilesh
		update tblInvoice Set IsDeleted = 1 Where PKID=@PKID
		Set @Operation='Invoice '+@Operation+' deleted'
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

