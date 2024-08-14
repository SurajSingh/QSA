CREATE PROCEDURE [dbo].[uspInsertRoleGroup]
	@PKRoleGroupID		Bigint			,
	@GroupName			Varchar(50)		,
	@OrgTypeID Varchar(2),
	@FKCompanyID			Bigint=null,	
	@DtRole			XML=null,
	@FKUserID			Bigint,
	@FKPageID			Bigint=0,
	@IPAddress			Varchar(50)
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Operation Varchar(50)
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		
		

		If(@PKRoleGroupID=0)
		Begin
				Exec uspGetNewID 'tblRoleGroup','PKRoleGroupID',@PKRoleGroupID output
				Insert Into tblRoleGroup(PKRoleGroupID, GroupName,OrgTypeID, FKCompanyID, FKCreatedBy, FKLastModifiedBy, CreationDate, ModificationDate)
				Values(@PKRoleGroupID, @GroupName, @OrgTypeID,@FKCompanyID,@FKUserID, @FKUserID, GETUTCDATE(), GETUTCDATE())
				Set @Operation='New Role Group '+@GroupName+' Added'
		End
		Else
		Begin
				Update tblRoleGroup Set GroupName=@GroupName,FKLastModifiedBy=@FKUserID,OrgTypeID=OrgTypeID, ModificationDate=@FKUserID
				Where PKRoleGroupID=@PKRoleGroupID
				Set @Operation='Role Group '+@GroupName+' Updated'
		End
		Delete From tblRoleGroupLnk Where FKRoleGroupID=@PKRoleGroupID
		if(@DtRole is not Null)
			begin
			Insert into tblRoleGroupLnk(FKRoleGroupID, FKRoleID, IsView, IsAdd, IsEdit, IsDelete)
			SELECT  @PKRoleGroupID,
			AddData.value('FKRoleID[1]', 'bigint') AS FKRoleID,     
			AddData.value('IsView[1]', 'bit') AS FKRoleID,
			AddData.value('IsAdd[1]', 'bit') AS isAdd,
			AddData.value('IsEdit[1]', 'bit') AS isEdit,
			AddData.value('IsDelete[1]', 'bit') AS isDelete
			FROM    @DtRole.nodes('NewDataSet/Table1') as X (AddData)
		end

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,@PKRoleGroupID
	End
		
	Select @Result as Result,@Msg as Msg

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH		
		ROLLBACK TRANSACTION
			Set @ErrorCount=@ErrorCount+1
			if(@ErrorCount>1)
			Begin
				Goto AddTran
			End
			Else
			Begin
				Set @Result=0
				Set @Msg = ERROR_MESSAGE()	
				Declare @SPName Varchar(200)
				Set @SPName=ERROR_PROCEDURE()	
				Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddress
				select @Result as Result,@Msg as Msg
			End
	END CATCH
End