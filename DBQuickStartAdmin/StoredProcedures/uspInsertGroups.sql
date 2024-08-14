CREATE PROCEDURE [dbo].[uspInsertGroups]
	@PKID	        Bigint,
	@GroupName		Varchar(200),
	@Description	Varchar(2000),
	@GroupItems		Varchar(max),
	@RecType		Varchar(50),
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
		
	IF(@RecType='Employee')
	Begin
		Select @Count=Count(*) From tblEmpGroup where FKCompanyID=@FKCompanyID and PKID<>@PKID and GroupName=@GroupName
		IF(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Group Name already exists!'
		End
	End
	Else IF(@RecType='Client')
	Begin
		Select @Count=Count(*) From tblClientGroup where FKCompanyID=@FKCompanyID and PKID<>@PKID and GroupName=@GroupName
		IF(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Group Name already exists!'
		End
	End
	Else IF(@RecType='Project')
	Begin
		Select @Count=Count(*) From tblProjectGroup where FKCompanyID=@FKCompanyID and PKID<>@PKID and GroupName=@GroupName
		IF(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Group Name already exists!'
		End
	End
	Else IF(@RecType='Expenses')
	Begin
		Select @Count=Count(*) From tblExpenseGroup where FKCompanyID=@FKCompanyID and PKID<>@PKID and GroupName=@GroupName
		IF(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Group Name already exists!'
		End
	End
	If(@Result=1)
	Begin
		

		If(@RecType='Employee')
		Begin
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblEmpGroup','PKID',@PKID output
				Insert Into tblEmpGroup(PKID, GroupName, Description,FKCompanyID,FKCreatedBy,CreationDate,ModificationDate)
				Values(@PKID,@GroupName, @Description,@FKCompanyID,@FKUserID,GETUTCDATE(),null)
				Set @Operation='New Employee Group '+@GroupName+' Added'
			End
			Else
			Begin
				Update tblEmpGroup Set  GroupName=@GroupName, Description=@Description,ModificationDate=GETUTCDATE(),FKLastModifiedBy=@FKUserID
				Where PKID=@PKID
				Set @Operation='Employee Group '+@GroupName+' Updated'
				Delete From tblEmpGroupDetail where FKID=@PKID
			End

			Insert into tblEmpGroupDetail(FKID,FKEmpID)
			Select @PKID,Item From dbo.FunSplitString(@GroupItems,',') where Item<>''
		End

		Else If(@RecType='Client')
		Begin
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblClientGroup','PKID',@PKID output
				Insert Into tblClientGroup(PKID, GroupName, Description,FKCompanyID,FKCreatedBy,CreationDate,ModificationDate)
				Values(@PKID,@GroupName, @Description,@FKCompanyID,@FKUserID,GETUTCDATE(),null)
				Set @Operation='New Client Group '+@GroupName+' Added'
			End
			Else
			Begin
				Update tblClientGroup Set  GroupName=@GroupName, Description=@Description,ModificationDate=GETUTCDATE(),FKLastModifiedBy=@FKUserID
				Where PKID=@PKID
				Set @Operation='Client Group '+@GroupName+' Updated'
				Delete From tblClientGroupDetail where FKID=@PKID
			End

			Insert into tblClientGroupDetail(FKID,FKClientID)
			Select @PKID,Item From dbo.FunSplitString(@GroupItems,',') where Item<>''
		End
		Else If(@RecType='Project')
		Begin
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblProjectGroup','PKID',@PKID output
				Insert Into tblProjectGroup(PKID, GroupName, Description,FKCompanyID,FKCreatedBy,CreationDate,ModificationDate)
				Values(@PKID,@GroupName, @Description,@FKCompanyID,@FKUserID,GETUTCDATE(),null)
				Set @Operation='New Project Group '+@GroupName+' Added'
			End
			Else
			Begin
				Update tblProjectGroup Set  GroupName=@GroupName, Description=@Description,ModificationDate=GETUTCDATE(),FKLastModifiedBy=@FKUserID
				Where PKID=@PKID
				Set @Operation='Project Group '+@GroupName+' Updated'
				Delete From tblProjectGroupDetail where FKID=@PKID
			End
			Insert into tblProjectGroupDetail(FKID,FKProjectID)
			Select @PKID,Item From dbo.FunSplitString(@GroupItems,',') where Item<>''
		End
		Else If(@RecType='Expenses')
		Begin
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblExpenseGroup','PKID',@PKID output
				Insert Into tblExpenseGroup(PKID, GroupName, Description,FKCompanyID,FKCreatedBy,CreationDate,ModificationDate)
				Values(@PKID,@GroupName, @Description,@FKCompanyID,@FKUserID,GETUTCDATE(),null)
				Set @Operation='New Expenses Group '+@GroupName+' Added'
			End
			Else
			Begin
				Update tblExpenseGroup Set  GroupName=@GroupName, Description=@Description,ModificationDate=GETUTCDATE(),FKLastModifiedBy=@FKUserID
				Where PKID=@PKID
				Set @Operation='Expenses Group '+@GroupName+' Updated'
				Delete From tblExpenseGroupDetail where FKID=@PKID
			End
			Insert into tblExpenseGroupDetail(FKID,FKExpID)
			Select @PKID,Item From dbo.FunSplitString(@GroupItems,',') where Item<>''
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
