CREATE PROCEDURE [dbo].[uspDeleteLocationTransfer]
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
	Select @count=count(*) From tblLocationTransfer Where  PKID=@PKID and FKCompanyID=@FKCompanyID
	Declare @PFKLocationID		Bigint,	@PFKDeptID	Bigint,	@PFKEmpID	Bigint,@PFKRepairPartyID	Bigint
	Declare @FKPrevID Bigint,@FKAssetID Bigint
	if(@count=0)
	Begin
		Set @Result=0
		Set @Msg='Invalid Operation'
	End

	If(@Result=1)
	Begin
		Select @count=count(*) From tblLocationTransfer Where  Isnull(FKPrevID,0)=@PKID and FKCompanyID=@FKCompanyID 
		if(@count>0)
		Begin
			Set @Result=0
			Set @Msg='Unable to delete record, Associated with the transfer entry.'
		End
	End
	if(@Result=1)
	Begin
		
		Select @FKPrevID=PKID,@FKAssetID=FKAssetID From tblLocationTransfer where PKID=@PKID
		Select @PFKLocationID=FKLocationID,@PFKDeptID=FKDeptID,@PFKEmpID=FKEmpID,@PFKRepairPartyID=FKRepairPartyID FRom tblLocationTransfer where PKID=@FKPrevID

		SElect @Operation=AssetName From tblAsset Where PKID=@FKAssetID
		Delete From tblLocationTransfer Where  PKID=@PKID
		
		Update tblAsset Set FKLocationID=@PFKLocationID,FKDeptID=@PFKDeptID,FKEmpID=@PFKEmpID,FKRepairPartyID=@PFKRepairPartyID
		where PKID=@FKAssetID


		Set @Operation='Asset transfer entry '+@Operation+' deleted'
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
