CREATE PROCEDURE [dbo].[uspInsertTimesheet]	
	@FKEmpID				Bigint,
	@FKManagerID			Bigint,
	@SubmitType				Varchar(50),
	@Action					Varchar(50),
	@ApproveRemark			Varchar(500),
	@TaskStatus             Varchar(50),
	@FKAssignLogID		    Bigint,
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
	Declare @NewPKID Bigint = 0
	Declare @Operation Varchar(50)	
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
	Declare @PKID Bigint=0
	Declare @JoinDate Date
	If(@Action='Submit')
	Begin
		If(@SubmitType='M')
		Begin
			Select @FKManagerID=FKManagerID From tblUser where PKUserID=@FKEmpID

			If(Isnull(@FKManagerID,0)=0)
			Begin
				Select @FKManagerID=PKUserID From tblUser where PKUserID=@FKEmpID and FKCompanyID=@FKCompanyID and IsDefaultUser=1
			End
		End
		Else IF(@SubmitType<>'S')
		Begin
			Set @FKManagerID=0
		End
	End

	Create table #tmpDetail(
				 PKID                   BIGINT,
				 NewPKID                BIGINT,
				 TaskDate               Date ,
                 FKTaskID               Bigint,                
				 FKProjectID            Bigint, 
				 Hrs                    DECIMAL (18,2),
                 Description            NVARCHAR (2000),
                 IsBillable             BIT,
                 Memo                   NVARCHAR (4000) ,
                 TBHours                DECIMAL (18,2),
                 TCostRate              DECIMAL (18, 4),
                 TBillRate              DECIMAL (18, 4),
				 FKSubmitToID			Bigint,
				 ModeForm			    Bigint
			)

			Insert Into #tmpDetail(PKID,NewPKID, TaskDate, FKTaskID,FKProjectID, Hrs, Description, IsBillable, Memo, TBHours, TCostRate, TBillRate, FKSubmitToID,ModeForm)			
			SELECT  AddData.value('PKID[1]', 'bigint') AS PKID, 
			0 As NewPKID,
			AddData.value('TaskDate[1]', 'Date') AS TaskDate,	
			AddData.value('FKTaskID[1]', 'bigint') AS FKTaskID,	
			AddData.value('FKProjectID[1]', 'bigint') AS FKProjectID,		
			AddData.value('Hrs[1]', 'DECIMAL (18,2)') AS Hrs,	
			AddData.value('Description[1]', ' NVARCHAR (2000)') AS Description,				
			AddData.value('IsBillable[1]', 'bit') AS IsBillable,
			AddData.value('Memo[1]', ' NVARCHAR (4000)') AS Memo,
			A.BHours,
			AddData.value('TCostRate[1]', 'DECIMAL (18,2)') AS TCostRate,	
			AddData.value('TBillRate[1]', 'DECIMAL (18,2)') AS TBillRate,
			Case When @Action='Submit' Then 
				Case When @SubmitType='M' Or @SubmitType='S' then @FKManagerID Else 
				 Case When @SubmitType='PM' Then P.FKManagerID Else C.FKManagerID End
				End
			Else T.FKSubmitToID End,			
			AddData.value('ModeForm[1]', 'bigint') AS ModeForm
			FROM    @dtItem.nodes('NewDataSet/Detail') as X (AddData)
			Left Join tblTask A On AddData.value('FKTaskID[1]', 'bigint')=A.PKID
			Left Join tblTimeSheet T On AddData.value('PKID[1]', 'bigint')=T.PKID
			Left Join tblProject P On AddData.value('FKProjectID[1]', 'bigint')=P.PKID
			Left Join tblClient C On P.FKClientID=C.PKID

			if(@FKAssignLogID<>0)
			Begin
				Update A Set TBHours=B.BHrs,TCostRate=T.CostRate,TBillRate=T.BillRate,IsBillable=T.IsBillable
				From #tmpDetail A
				Inner Join tblTaskAssignment B on B.PKID=@FKAssignLogID
				Inner Join tblTask T on B.FKTaskID=T.PKID
			End
		
		If(@Action='Submit')
		Begin
			Select @JoinDate=JoinDate From tblUser where PKUserID=@FKEmpID


			Select @Count=COUNT(*) from #tmpDetail Where ModeForm=0 and TaskDate<@JoinDate
			If(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='You can not enter time before '+convert(varchar(12),CONVERT(Varchar(50),@JoinDate,109))
			End
		End


		If(@Result=1)
		Begin
			Delete FRom tblTimeSheet
			Where PKID in (Select PKID From #tmpDetail where ModeForm<>0)

			Update A Set TaskDate=B.TaskDate, FKTaskID=B.FKTaskID, FKProjectID=B.FKProjectID, Hrs=B.Hrs, 
			Description=B.Description, IsBillable=B.IsBillable, Memo=B.Memo, TBHours=B.TBHours, TCostRate=B.TCostRate, 
			TBillRate=B.TBillRate, FKSubmitToID=Case when B.FKSubmitToID=0 then Null Else B.FKSubmitToID End, 
			FKLastModifiedBy=Case When @Action='Submit' then @FKUserID Else A.FKLastModifiedBy End, 
			ModificationDate=Case When @Action='Submit' then GETUTCDATE() Else A.ModificationDate End,
			TaskStatus=Case when @FKAssignLogID<>0 then @TaskStatus Else TaskStatus End
			From tblTimeSheet A
			Inner Join #tmpDetail B on A.PKID=B.PKID
			Where B.ModeForm=0

			If(@Action='Submit')
			Begin
				Declare @PKDetailID Bigint=0		
				Exec uspGetNewID 'tblTimeSheet','PKID',@PKDetailID output,0
				Set @PKDetailID=@PKDetailID-1
				
				Update #tmpDetail Set  @PKDetailID = NewPKID = @PKDetailID + 1		
				Where PKID=0 And ModeForm=0
				
				Set @NewPKID = @PKDetailID

				Insert Into tblTimeSheet(PKID,FKCompanyID,TaskDate,FKTaskID, FKEmpID, FKProjectID, Hrs, Description, IsBillable, Memo, TBHours, TCostRate, TBillRate, FKSubmitToID,	FKCreatedBy, CreationDate,FKAssignLogID,TaskStatus)
				Select NewPKID,@FKCompanyID,TaskDate,FKTaskID, @FKEmpID, FKProjectID, Hrs, Description, IsBillable, Memo, TBHours, TCostRate, TBillRate, Case when FKSubmitToID=0 then Null Else FKSubmitToID End, 
				@FKUserID, GETUTCDATE(),Case When @FKAssignLogID=0 then Null Else @FKAssignLogID End,@TaskStatus
				From #tmpDetail
				Where PKID=0 And ModeForm=0


			End
			Else
			Begin
				Update A Set ApproveStatus=@Action,FKApproveByID=@FKUserID,ApproveDate=GETUTCDATE(),ApproveRemark=@ApproveRemark
				From tblTimeSheet A
				Inner Join #tmpDetail B on A.PKID=B.PKID
				Where B.ModeForm=0
 

			End
			
			Declare @PTaskDate Date
			if(@FKAssignLogID<>0)
			Begin
				Set @Count=0
				if(@TaskStatus='Completed')
				Begin
					Update tblTaskAssignment Set CurrentStatus=@TaskStatus Where PKID=@FKAssignLogID
				End
				Else
				Begin
					Select top 1 @PKID=PKID,@PTaskDate=TaskDate From #tmpDetail where ModeForm=0
					If(@PKID<>0)
					Begin
						Select @Count=Count(*) From tblTimeSheet where FKAssignLogID=@FKAssignLogID and PKID>@PKID and TaskDate>=@PTaskDate
					End
					If(@Count=0)
					Begin
						Update tblTaskAssignment Set CurrentStatus=@TaskStatus Where PKID=@FKAssignLogID
					End
				End				

			End
		End

			

	If(@CallFromSP=0)
	Begin
		Select @Result as Result,@Msg as Msg, @NewPKID as PKID
		
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

