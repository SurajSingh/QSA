CREATE PROCEDURE [dbo].[uspInsertProductBudget]
	@PKID				Bigint,
	@BudgetTitle		Varchar(200),
	@FromDate			Date,
	@ToDate				Date,
	@FKProjectID		Bigint,
	@dtItem					XML,		
	@FKCompanyID			Bigint,	
	@FKUserID				Bigint,	
	@FKPageID				Bigint=0,
	@IPAddress				Varchar(50)	
	
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
	Declare @PKIDNewID Bigint=0
	Declare @JoinDate Date
	

	Create table #tmpDetail(
				 PKID                   BIGINT,
				 NewPKID                BIGINT,				
                 FKTaskID               Bigint,
                 BudHrs				    Decimal(18,2),
				 CostRate			    DECIMAL (18, 4) ,
				 BillRate				DECIMAL (18, 4) ,
				 IsBillable				BIT,
				 ModeForm			    Bigint
			)

			Insert Into #tmpDetail(PKID,NewPKID, FKTaskID,BudHrs, CostRate, BillRate, IsBillable,ModeForm)			
			SELECT  AddData.value('PKID[1]', 'bigint') AS PKID, 
			0 As NewPKID,			
			AddData.value('FKTaskID[1]', 'bigint') AS FKTaskID,					
			AddData.value('BudHrs[1]', 'DECIMAL (18,2)') AS BudHrs,	
			AddData.value('CostRate[1]', 'DECIMAL (18,2)') AS CostRate,	
			AddData.value('BillRate[1]', 'DECIMAL (18,2)') AS BillRate,	
			AddData.value('IsBillable[1]', 'bit') AS IsBillable,			
			AddData.value('ModeForm[1]', 'bigint') AS ModeForm
			FROM    @dtItem.nodes('NewDataSet/Detail') as X (AddData)
			Left Join tblTask A On AddData.value('FKTaskID[1]', 'bigint')=A.PKID
			Left Join tblTimeSheet T On AddData.value('PKID[1]', 'bigint')=T.PKID
			Left Join tblProject P On AddData.value('FKProjectID[1]', 'bigint')=P.PKID
			Left Join tblClient C On P.FKClientID=C.PKID

			
		
		


		If(@Result=1)
		Begin
			
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblProjectBudget','PKID',@PKID output,0
				Insert Into tblProjectBudget(PKID,FKProjectID,BudgetTitle,FromDate,ToDate,FKCompanyID,FKCreatedBy,CreationDate)
				values(@PKID,@FKProjectID,@BudgetTitle,@FromDate,@ToDate,@FKCompanyID,@FKUserID,GETUTCDATE())
			End
			Else
			Begin
				Update tblProjectBudget Set FKProjectID=@FKProjectID,BudgetTitle=@BudgetTitle,FromDate=@FromDate,ToDate=@ToDate,FKLastModifiedBy=@FKUserID,ModificationDate=GETUTCDATE()
				where PKID=@PKID
			End
			
			Delete FRom tblBudgetDetail
			Where PKID in (Select PKID From #tmpDetail where ModeForm<>0)

			Update A Set FKTaskID=B.FKTaskID, BudHrs=B.BudHrs, 
			 IsBillable=B.IsBillable, CostRate=B.CostRate, 
			BillRate=B.BillRate
			From tblBudgetDetail A
			Inner Join #tmpDetail B on A.PKID=B.PKID
			Where B.ModeForm=0

			Declare @PKDetailID Bigint=0		
			Exec uspGetNewID 'tblBudgetDetail','PKID',@PKDetailID output,0
			Set @PKDetailID=@PKDetailID-1
				
			Update #tmpDetail Set  @PKDetailID = NewPKID = @PKDetailID + 1		
			Where PKID=0 And ModeForm=0
				
				Insert Into tblBudgetDetail(PKID,FKBudgetID,FKTaskID, BudHrs, IsBillable,  CostRate, BillRate)
				Select NewPKID,@PKID,FKTaskID, BudHrs, IsBillable,  CostRate, BillRate
				From #tmpDetail
				Where PKID=0 And ModeForm=0
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
				select @Result as Result,@Msg as Msg,ERROR_LINE() as [LineNo],@SPName as SPName
	END CATCH
End
