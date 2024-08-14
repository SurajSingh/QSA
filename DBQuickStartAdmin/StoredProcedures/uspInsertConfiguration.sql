CREATE PROCEDURE [dbo].[uspInsertConfiguration]
	@tblData			XML,
	@FKCompanyID		Bigint,
	@FKBranchID			Bigint,
	@FKUserID			Bigint,	
	@FKPageID			Bigint=0,
	@IPAddress			Varchar(50)
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Count Bigint=0
	Declare @Operation Varchar(50)='Update in System Configuration'
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
	


	if(@Result=1)
	Begin
		
			

			Create table #tmpConfiguration
			(				
				KayName				Varchar(200),	
				KayVal				Varchar(1000),	
				ApplyOn				Varchar(2),
				SepForBranch			Bit
			) 
			Insert into #tmpConfiguration
			SELECT  
			AddData.value('KayName[1]', 'Varchar(200)') AS KayName,
			AddData.value('KayVal[1]', 'Varchar(1000)') AS KayVal,
			AddData.value('ApplyOn[1]', 'Varchar(50)') AS ApplyOn,
			Isnull(AddData.value('SepForBranch[1]', 'Bit'),0) AS SepForBranch
			FROM    @tblData.nodes('NewDataSet/Table1') as X (AddData)

			Update tblConfiguration Set KayVal=#tmpConfiguration.KayVal,
			ApplyOn=#tmpConfiguration.ApplyOn,
			ModificationDate=GETUTCDATE()
			From #tmpConfiguration
			Where tblConfiguration.KayName=#tmpConfiguration.KayName
			And tblConfiguration.FKCompanyID=@FKCompanyID And
			#tmpConfiguration.SepForBranch=0 and tblConfiguration.FKBranchID is null

			Update tblConfiguration Set KayVal=#tmpConfiguration.KayVal,
			ApplyOn=#tmpConfiguration.ApplyOn,
			ModificationDate=GETUTCDATE()
			From #tmpConfiguration
			Where tblConfiguration.KayName=#tmpConfiguration.KayName
			And tblConfiguration.FKCompanyID=@FKCompanyID And
			#tmpConfiguration.SepForBranch=1 and tblConfiguration.FKBranchID=@FKBranchID
			
			

			Insert Into tblConfiguration(KayName,KayVal,ApplyOn,FKCompanyID,FKBranchID,ModificationDate)
			Select KayName,KayVal,ApplyOn,@FKCompanyID,@FKBranchID,GETUTCDATE() From #tmpConfiguration
			Where KayName Not In (Select KayName From tblConfiguration Where FKCompanyID=@FKCompanyID And FKBranchID=@FKBranchID)	
			And SepForBranch=1

			Insert Into tblConfiguration(KayName,KayVal,ApplyOn,FKCompanyID,FKBranchID,ModificationDate)
			Select KayName,KayVal,ApplyOn,@FKCompanyID,null,GETUTCDATE() From #tmpConfiguration
			Where KayName Not In (Select KayName From tblConfiguration Where FKCompanyID=@FKCompanyID And Isnull(FKBranchID,0)=0)	
			And SepForBranch=0

	End

	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddress,@Operation,0
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
				Exec sp_InsertErrorLog 0,'SP',@SPName,@Msg,''
				select @Result as Result,@Msg as Msg,ERROR_LINE()
	END CATCH
End
