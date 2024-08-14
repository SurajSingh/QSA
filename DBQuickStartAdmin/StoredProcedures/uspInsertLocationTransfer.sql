CREATE PROCEDURE [dbo].[uspInsertLocationTransfer]
	@PKID               BIGINT,
	@TranDate			Date,
    @FKAssetID			BIGINT,	
	@FKLocationID		Bigint,
	@FKDeptID			Bigint,
	@FKEmpID			Bigint,
	@FKRepairPartyID	Bigint,
	@Remarks			Varchar(50),
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
		
		
		Declare @PFKLocationID		Bigint,	@PFKDeptID	Bigint,	@PFKEmpID	Bigint,@PFKRepairPartyID	Bigint
		Declare @FKPrevID Bigint
		
		Declare @Count Bigint=0
		Declare @Operation Varchar(100)=''
		DEclare @SNo	Bigint,@EntryID	Varchar(50)

		--Validate 
		
		if(@Result=1)
		Begin
			
			Select @PFKLocationID=FKLocationID,@PFKDeptID=FKDeptID,@PFKEmpID=FKEmpID,@PFKRepairPartyID=FKRepairPartyID FRom tblAsset where PKID=@FKAssetID

			
			If(Isnull(@PFKLocationID,0)=@FKLocationID And Isnull(@PFKDeptID,0)=@FKDeptID and Isnull(@PFKEmpID,0)=@FKEmpID And Isnull(@PFKRepairPartyID,0)=@FKRepairPartyID)
			Begin
				Set @Result=0
				Set @Msg='Previous and current asset location is same!'
			End
		End
		
		If(@Result=1)
		Begin
		
			

			Select top 1 @FKPrevID=PKID From tblLocationTransfer where FKCompanyID=@FKCompanyID
			And Isnull(FKLocationID,0)=Isnull(@PFKLocationID,0) And Isnull(FKDeptID,0)=Isnull(@PFKDeptID,0)
			And Isnull(FKEmpID,0)=Isnull(@PFKEmpID,0) and Isnull(FKRepairPartyID,0)=Isnull(@PFKRepairPartyID,0)
			Order by PKID Desc


			If(@FKDeptID=0)
			Set @FKDeptID=null
			If(@FKEmpID=0)
			Set @FKEmpID=null
			If(@FKRepairPartyID=0)
			Set @FKRepairPartyID=null

			If(@FKPrevID=0)
			Set @FKPrevID=Null
			
			Select @SNo=max(SNo) from tblLocationTransfer where FKCompanyID=@FKCompanyID
			Set @SNo=Isnull(@SNo,1000)+1

			Set @EntryID=@SNo

			Exec uspGetNewID 'tblLocationTransfer','PKID',@PKID output
			SElect @Operation=AssetName From tblAsset Where PKID=@FKAssetID


			Insert into tblLocationTransfer(PKID,SNo,EntryID, TranDate, FKAssetID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID, FKPrevID, FKCompanyID, FKCreatedBy, CreationDate)
			values(@PKID,@SNo,@EntryID, @TranDate, @FKAssetID, @FKLocationID, @FKDeptID, @FKEmpID, @FKRepairPartyID, @FKPrevID, @FKCompanyID, @FKUserID, GETUTCDATE())

			Update tblAsset Set FKLocationID=@FKLocationID,FKDeptID=@FKDeptID,FKEmpID=@FKEmpID,FKRepairPartyID=@FKRepairPartyID
			where PKID=@FKAssetID

			Set @Operation='Transfer asset '+@Operation+' to a new location'

			


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

