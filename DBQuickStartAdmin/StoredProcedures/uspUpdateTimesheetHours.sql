CREATE PROCEDURE [dbo].[uspUpdateTimesheetHours]
@PKID Bigint,
@Hours DECIMAL (18,2)	

AS
Begin
	--Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Count Bigint=0
	--Declare @pastHours Decimal(18,2)
	--Declare @TotalHours Decimal(18,2)
	--Declare @Operation Varchar(50)
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY

	--set @pastHours = (select Hrs from tblTimeSheet where PKID = @PKID)

	If(@PKID=0)
	Set @Msg = ERROR_MESSAGE()	

	If(@Hours=0)
	Set @Hours=null		

	--SET @TotalHours = @pastHours + @Hours

	Update tblTimeSheet Set Hrs=@Hours
	where PKID=@PKID

	Select @Result as Result,@Msg as Msg	
		
	COMMIT TRANSACTION		
	END TRY
	BEGIN CATCH
		
		ROLLBACK TRANSACTION
			
			Set @Result=0
				Set @Msg = ERROR_MESSAGE()	
				Declare @SPName Varchar(200)
				Set @SPName=ERROR_PROCEDURE()	
				Exec sp_InsertErrorLog 0,'SP',@SPName,@Msg,''
				select @Result as Result,@Msg as Msg,ERROR_LINE()
	END CATCH
End