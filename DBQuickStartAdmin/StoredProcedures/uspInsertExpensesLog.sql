CREATE PROCEDURE [dbo].[uspInsertExpensesLog]
	@FKEmpID				Bigint,	
	@Action					Varchar(50),
	@ApproveRemark			Varchar(500),
	@dtItem					XML,		
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

	

	Create table #tmpDetail(
				 PKID                   BIGINT,
				 NewPKID                BIGINT,
				 TaskDate               Date ,
                 FKTaskID               Bigint,                
				 FKProjectID            Bigint, 
				 Unit                    DECIMAL (18,4),
                 Description            NVARCHAR (2000),
                 IsBillable             BIT,
                 Memo                   NVARCHAR (4000) ,                
                 TCostRate              DECIMAL (18, 4),
                 MU                     DECIMAL (18, 4),
				 Amount					DECIMAL (18, 4),
				 IsReimb                 BIT ,
				 SavedFileName          Varchar(max),
				 OriginalFileName        Varchar(max),
				 ModeForm			    Bigint
			)

			Insert Into #tmpDetail(PKID,NewPKID, TaskDate, FKTaskID,FKProjectID, Unit, Description, IsBillable, Memo, TCostRate, MU, Amount,IsReimb,SavedFileName,OriginalFileName,ModeForm)			
			SELECT  AddData.value('PKID[1]', 'bigint') AS PKID, 
			0 As NewPKID,
			AddData.value('TaskDate[1]', 'Date') AS TaskDate,	
			AddData.value('FKTaskID[1]', 'bigint') AS FKTaskID,	
			AddData.value('FKProjectID[1]', 'bigint') AS FKProjectID,		
			AddData.value('Unit[1]', 'DECIMAL (18,2)') AS Unit,	
			AddData.value('Description[1]', ' NVARCHAR (2000)') AS Description,				
			AddData.value('IsBillable[1]', 'bit') AS IsBillable,
			AddData.value('Memo[1]', ' NVARCHAR (4000)') AS Memo,			
			AddData.value('TCostRate[1]', 'DECIMAL (18,4)') AS TCostRate,	
			AddData.value('MU[1]', 'DECIMAL (18,4)') AS MU,
			AddData.value('Amount[1]', 'DECIMAL (18,4)') AS Amount,		
			AddData.value('IsReimb[1]', 'bit') AS IsReimb,
			AddData.value('SavedFileName[1]', ' VARCHAR (max)') AS SavedFileName,	
			AddData.value('OriginalFileName[1]', ' VARCHAR (max)') AS OriginalFileName,	
			AddData.value('ModeForm[1]', 'bigint') AS ModeForm
			FROM    @dtItem.nodes('NewDataSet/Detail') as X (AddData)
			Left Join tblTask A On AddData.value('FKTaskID[1]', 'bigint')=A.PKID
			Left Join tblExpensesLog T On AddData.value('PKID[1]', 'bigint')=T.PKID
			Left Join tblProject P On AddData.value('FKProjectID[1]', 'bigint')=P.PKID
			Left Join tblClient C On P.FKClientID=C.PKID

			Delete FRom tblExpensesLog
			Where PKID in (Select PKID From #tmpDetail where ModeForm<>0)

			Update A Set TaskDate=B.TaskDate, FKTaskID=B.FKTaskID, FKProjectID=B.FKProjectID, Unit=B.Unit, 
			Description=B.Description, IsBillable=B.IsBillable, Memo=B.Memo, TCostRate=B.TCostRate, 
			MU=B.MU, Amount=B.Amount,IsReimb=B.IsReimb,OriginalFileName=A.OriginalFileName,SavedFileName=A.SavedFileName, 
			FKLastModifiedBy=Case When @Action='Submit' then @FKUserID Else A.FKLastModifiedBy End, 
			ModificationDate=Case When @Action='Submit' then GETUTCDATE() Else A.ModificationDate End
			From tblExpensesLog A
			Inner Join #tmpDetail B on A.PKID=B.PKID
			Where B.ModeForm=0

			If(@Action='Submit')
			Begin
				Declare @PKDetailID Bigint=0		
				Exec uspGetNewID 'tblExpensesLog','PKID',@PKDetailID output,0
				Set @PKDetailID=@PKDetailID-1
				
				Update #tmpDetail Set  @PKDetailID = NewPKID = @PKDetailID + 1		
				Where PKID=0 And ModeForm=0
				
				Insert Into tblExpensesLog(PKID,FKCompanyID,TaskDate,FKTaskID, FKEmpID, FKProjectID, Unit, Description, IsBillable, Memo, TCostRate, MU, Amount,IsReimb,SavedFileName,OriginalFileName,	FKCreatedBy, CreationDate)
				Select NewPKID,@FKCompanyID,TaskDate,FKTaskID, @FKEmpID, FKProjectID, Unit, Description, IsBillable, Memo, TCostRate, MU,Amount,IsReimb, SavedFileName,OriginalFileName,
				@FKUserID, GETUTCDATE()
				From #tmpDetail
				Where PKID=0 And ModeForm=0


			End
			Else
			Begin
				Update A Set ApproveStatus=@Action,FKApproveByID=@FKUserID,ApproveDate=GETUTCDATE(),ApproveRemark=@ApproveRemark
				From tblExpensesLog A
				Inner Join #tmpDetail B on A.PKID=B.PKID
				Where B.ModeForm=0
 

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


