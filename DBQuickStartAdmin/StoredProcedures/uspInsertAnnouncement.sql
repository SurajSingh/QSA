CREATE PROCEDURE [dbo].[uspInsertAnnouncement]
	@PKID	        Bigint,
	@Title			Varchar(500),
	@DisplayDate	Date, 
	@Announcement	NVarchar(2000),
	@ActiveStatus	Varchar(50),
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
		
		

	If(@Result=1)
	Begin
		

		If(@PKID=0)
		Begin
				Exec uspGetNewID 'tblAnnouncement','PKID',@PKID output
				Insert Into tblAnnouncement(PKID, Title, DisplayDate,Announcement,ActiveStatus,FKCompanyID,CreationDate,ModificationDate)
				Values(@PKID,@Title, @DisplayDate,@Announcement,@ActiveStatus,  @FKCompanyID,GETUTCDATE(),null)
				Set @Operation='New Announcement '+@Title+' Added'
		End
		Else
		Begin
				Update tblAnnouncement Set  Title=@Title, DisplayDate=@DisplayDate,Announcement=@Announcement,ActiveStatus=@ActiveStatus,ModificationDate=GETUTCDATE(),FKLastModifiedBy=@FKUserID
				Where PKID=@PKID
				Set @Operation='Announcement '+@Title+' Updated'
		End
	End

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKID
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
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddress
			select @Result as Result,@Msg as Msg
	END CATCH
End
