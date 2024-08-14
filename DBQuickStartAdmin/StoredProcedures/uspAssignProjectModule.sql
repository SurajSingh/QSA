CREATE PROCEDURE [dbo].[uspAssignProjectModule]
	@FKForcastingID			Bigint,
	@FKEmpID				Bigint,
	@FKManagerID			Bigint,
	@AssignDate				Date,	
	@FKCompanyID			Bigint,	
	@FKUserID				Bigint,	
	@FKPageID				Bigint=0,
	@IPAddress				Varchar(50),	
	@CallFromSP				Bit
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Count Bigint=0
	Declare @Operation Varchar(50)	
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY

			Select @Count=COUNT(*) From tblTaskAssignment where FKEmpID=@FKEmpID and FKProjectForecastingID=@FKForcastingID
			If(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Activity is already assigned to selected employee'
			End
			If(@Result=1)
			Begin
				Declare @PKDetailID Bigint=0		
				Exec uspGetNewID 'tblTaskAssignment','PKID',@PKDetailID output,0
			
				Insert Into tblTaskAssignment(PKID,FKCompanyID,AssignDate,FKTaskID, FKEmpID, FKProjectID, BHrs, Description, Remark, FKManagerID,TimeTaken,	FKCreatedBy, CreationDate,FKProjectForecastingID)
				Select @PKDetailID,@FKCompanyID,@AssignDate,FKTaskID, @FKEmpID, FKProjectID, EstHrs, ModuleDesc,'',@FKManagerID,0 ,
				@FKUserID, GETUTCDATE(),@FKForcastingID
				From tblProjectModule
				Where PKID=@FKForcastingID
			End
			
			
				
			
			

			

	If(@CallFromSP=0)
	Begin
		Select @Result as Result,@Msg as Msg
		
	End

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
