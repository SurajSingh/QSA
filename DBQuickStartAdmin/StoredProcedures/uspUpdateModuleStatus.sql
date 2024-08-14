CREATE PROCEDURE [dbo].[uspUpdateModuleStatus]
	@PKID			        Bigint,
	@NewStatus				Varchar(50),
	@NewDate			    Date,	
	@CompletePer			Bigint,
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

			If(@NewStatus='Started')
			Begin
				Update tblProjectModule Set StartDate=@NewDate,TaskStatus=@NewStatus,CompletePer=0,EndDate=null where PKID=@PKID
			End
			Else If(@NewStatus='Process')
			Begin
				Update tblProjectModule Set CompletePer=@CompletePer,TaskStatus=@NewStatus,EndDate=null where PKID=@PKID
			End
			Else If(@NewStatus='Complete')
			Begin
				Update tblProjectModule Set CompletePer=100,TaskStatus=@NewStatus,EndDate=@NewDate where PKID=@PKID
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
