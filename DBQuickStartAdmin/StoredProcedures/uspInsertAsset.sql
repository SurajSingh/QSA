CREATE PROCEDURE [dbo].[uspInsertAsset]
	@PKID               BIGINT,
    @AssetCode			Varchar(50),
	@AssetName			Varchar(50),
	@AssetDesc			Varchar(500),
	@FKCategoryID		Bigint, 
	@Manufacturer		Varchar(50),
	@FKPartyID			Bigint, 
	@PurchaseRate		Decimal(18,4),
	@CurrentRate		Decimal(18,4),
	@PurchaseDate		Date,
	@InvoiceID			Varchar(50),
	@PONo				Varchar(50),
	@Barcode			Varchar(50),
	@SerialNo			Varchar(50),
	@Remarks			Varchar(50),
	@ImgURL				Varchar(50),
	@FKConditionID		Bigint, 
	@FKLocationID		Bigint,
	@FKDeptID			Bigint,
	@FKEmpID			Bigint,
	@FKRepairPartyID	Bigint,
	@FKCompanyID		Bigint, 
	@FKUserID			Bigint,	
	@FKPageID		    Bigint=0,
	@IPAddr			    Varchar(50)

AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		
		
		Declare @PKTransferID Bigint=0
	
		If(@FKDeptID=0)
		Set @FKDeptID=null
		If(@FKEmpID=0)
		Set @FKEmpID=null
		If(@FKRepairPartyID=0)
		Set @FKRepairPartyID=null
		If(@FKPartyID=0)
		Set @FKPartyID=null
		


		Declare @Count Bigint=0
		Declare @Operation Varchar(100)=''
		Declare @PFKLocationID		Bigint,	@PFKDeptID	Bigint,	@PFKEmpID	Bigint,@PFKRepairPartyID	Bigint
		DEclare @SNo	Bigint,@EntryID	Varchar(50)

		
		

		--Validate 
		if(@Result=1)
		Begin
			Select @Count=count(*) from tblAsset where PKID<>@PKID  and AssetCode=@AssetCode and FKCompanyID=@FKCompanyID
			If(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Asset Code  already exists!'
			End
		End
		if(@Result=1 and @Barcode<>'')
		Begin
			Select @Count=count(*) from tblAsset where PKID<>@PKID  and Barcode=@Barcode and FKCompanyID=@FKCompanyID
			If(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Barcode  already exists!'
			End
		End

		If(@Result=1 and @PKID<>0)
		Begin
			Select @PFKLocationID=FKLocationID,@PFKDeptID=FKDeptID,@PFKEmpID=FKEmpID,@PFKRepairPartyID=FKRepairPartyID FRom tblAsset where PKID=@PKID
			
			If(Isnull(@PFKLocationID,0)=@FKLocationID And Isnull(@PFKDeptID,0)=@FKDeptID and Isnull(@PFKEmpID,0)=@FKEmpID And Isnull(@PFKRepairPartyID,0)=@FKRepairPartyID)
			Begin
				Set @Result=1				
			End
			Else
			Begin
				Select @Count=COUNT(*) from tblLocationTransfer where FKAssetID=@PKID
				If(@Count>1)
				Begin
					Set @Result=0
					Set @Msg='Unable to change asset location. Please use Transfer Asset option!'
				End
			End
		End
		
		If(@Result=1)
		Begin			
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblAsset','PKID',@PKID output
				Insert Into tblAsset(PKID, AssetCode, AssetName, AssetDesc, FKCategoryID, Manufacturer, FKPartyID, PurchaseRate, CurrentRate, PurchaseDate, InvoiceID, PONo, Barcode, SerialNo, Remarks, ImgURL, FKConditionID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID, FKCompanyID, FKCreatedBy, CreationDate)
				Values(@PKID, @AssetCode, @AssetName, @AssetDesc, @FKCategoryID, @Manufacturer, @FKPartyID, @PurchaseRate, @CurrentRate, @PurchaseDate, @InvoiceID, @PONo, @Barcode, @SerialNo, @Remarks, @ImgURL, @FKConditionID, @FKLocationID, @FKDeptID, @FKEmpID, @FKRepairPartyID, @FKCompanyID, @FKUserID, GETUTCDATE())				
				
				Set @Operation='New Asset '+@AssetName+' Added'


				Exec uspGetNewID 'tblLocationTransfer','PKID',@PKTransferID output

				Select @SNo=max(SNo) from tblLocationTransfer where FKCompanyID=@FKCompanyID
				Set @SNo=Isnull(@SNo,1000)+1

				Set @EntryID=@SNo
				Insert into tblLocationTransfer(PKID,SNo,EntryID, TranDate, FKAssetID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID, FKPrevID, FKCompanyID, FKCreatedBy, CreationDate)
				values(@PKTransferID,@SNo,@EntryID, @PurchaseDate, @PKID, @FKLocationID, @FKDeptID, @FKEmpID, @FKRepairPartyID, null, @FKCompanyID, @FKUserID, GETUTCDATE())


			End
			Else
			Begin
				Update tblAsset Set AssetCode=@AssetCode, AssetName=@AssetName, AssetDesc=@AssetDesc, FKCategoryID=@FKCategoryID, 
				Manufacturer=@Manufacturer, FKPartyID=@FKPartyID, PurchaseRate=@PurchaseRate, CurrentRate=@CurrentRate, PurchaseDate=@PurchaseDate, InvoiceID=@InvoiceID, PONo=@PONo, Barcode=@Barcode, SerialNo=@SerialNo, Remarks=@Remarks, 
				ImgURL=@ImgURL, FKConditionID=@FKConditionID, FKLocationID=@FKLocationID, FKDeptID=@FKDeptID, FKEmpID=@FKEmpID, FKRepairPartyID=@FKRepairPartyID, 
				FKLastModifiedBy=@FKUserID, ModificationDate=GETUTCDATE()
				Where PKID=@PKID And FKCompanyID=@FKCompanyID				

				Set @Operation='Aseet  '+@AssetName+' Updated'

				Select @Count=COUNT(*) from tblLocationTransfer where FKAssetID=@PKID

				If(@Count=1)
				Begin
					Update tblLocationTransfer Set TranDate=@PurchaseDate, FKAssetID=@PKID, FKLocationID=@FKLocationID, 
					FKDeptID=@FKDeptID, FKEmpID=@FKEmpID, FKRepairPartyID=@FKRepairPartyID, FKLastModifiedBy=@FKUserID, ModificationDate=GETUTCDATE()
					Where FKAssetID=@PKID and ISNULL(FKPrevID,0)=0
				End


			End


			


		End		

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddr,@Operation,@PKID
	End
	Select @Result as Result,@Msg as Msg
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH		
		ROLLBACK TRANSACTION
			Set @Result=0
			Set @Msg = ERROR_MESSAGE()	
			Declare @SPName Varchar(200)
			Set @SPName=ERROR_PROCEDURE()	
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddr
			select @Result as Result,@Msg as Msg
	END CATCH
End

