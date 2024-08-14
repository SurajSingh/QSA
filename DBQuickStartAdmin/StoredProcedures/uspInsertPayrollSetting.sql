CREATE PROCEDURE [dbo].[uspInsertPayrollSetting]
	@PKID				BIGINT,	
	@StartMonth			Varchar(2),
	@EndMonth			Varchar(2),
	@LeaveRule			Bigint,
	@dtItem				XML,		
	@FKCompanyID		Bigint,	
	@FKUserID			Bigint,	
	@FKPageID			Bigint=0,
	@IPAddress			Varchar(50)	
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
	Declare @PNetAmount Decimal(18,4)
	Declare @FKPClientID Decimal(18,4)
	Declare @FKClientID Decimal(18,4)
	DEclare @PRetainage	Decimal(18,4)
	Declare @InvoiceID	Varchar(500)
	Declare @ISCustomInvoice	Bit=0
	Declare @ProjectSNo	Bigint=0
	Declare @NextInvNo	Bigint=0
	Declare @FKPayTermID Bigint=0
	Declare @PaymentTerm	NVarchar(2000)
	Declare @DueAmount Decimal(18,4)
	Declare @PKTranID Bigint=0
	 

	If(@PKID<>0)
	Begin
		Select @Count=Count(*) FRom tblPayrollSetting where PKID=@PKID and FKCompanyID=@FKCompanyID
		If(@Count=0)
		Begin
			Set @Result=0
			Set @Msg='Invalid Operation'
		End
	End

	Create table #tmpDetail(
				PKID			Bigint,
				NewPKID		    Bigint,
				LeaveName		Varchar(50),
				PayType			Varchar(50),
				PerMonthAccr	Decimal(18,2),
				LeaveCount		Decimal(18,2),
				CFNextYear		Bit,
				ModeForm	    Bigint
			)

			Insert Into #tmpDetail			
			SELECT  AddData.value('PKID[1]', 'bigint') AS PKID,
			0 as FKSettingID,
			AddData.value('LeaveName[1]', 'varchar(50)') AS LeaveName,	
			AddData.value('PayType[1]', 'varchar(50)') AS PayType,	
			AddData.value('PerMonthAccr[1]', 'DECIMAL (18,2)') AS PerMonthAccr,	
			AddData.value('LeaveCount[1]', 'DECIMAL (18,2)') AS LeaveCount,	
			AddData.value('CFNextYear[1]', 'Bit') AS CFNextYear,			
			AddData.value('ModeForm[1]', 'bigint') AS ModeForm
			FROM    @dtItem.nodes('NewDataSet/Leave') as X (AddData)
			
		Create table #tmpWeekDays(
				PKID			Bigint,
				NewPKID		    Bigint,
				DayNum			Bigint,
				IsOn			Bit,
				StartTime		Time,
				EndTime			Time,
				ModeForm	    Bigint
			)

			Insert Into #tmpWeekDays			
			SELECT  AddData.value('PKID[1]', 'bigint') AS PKID,
			0 as FKSettingID,
			AddData.value('DayNum[1]', 'Bigint') AS DayNum,	
			AddData.value('IsOn[1]', 'Bit') AS   IsOn,	
			AddData.value('StartTime[1]', 'Time') AS StartTime,	
			AddData.value('EndTime[1]', 'Time') AS EndTime,					
			AddData.value('ModeForm[1]', 'bigint') AS ModeForm
			FROM    @dtItem.nodes('NewDataSet/WeekDays') as X (AddData)
			

		If(@Result=1)
		Begin
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblPayrollSetting','PKID',@PKID output
				Insert Into tblPayrollSetting(PKID, StartMonth, EndMonth, LeaveRule, FKCompanyID, CreationDate)
				Values(@PKID, @StartMonth, @EndMonth, @LeaveRule, @FKCompanyID, GETUTCDATE())				
				
			End
			Else
			Begin
				Update tblPayrollSetting Set StartMonth=@StartMonth, EndMonth=@EndMonth, LeaveRule=@LeaveRule,ModificationDate=GETUTCDATE()
				Where PKID=@PKID And FKCompanyID=@FKCompanyID	
				
				DElete FRom tblPayrollSettingLeave Where PKID in (Select PKID From #tmpDetail Where PKID<>0 and ModeForm<>0) and FKSettingID=@PKID

				Update tblPayrollSettingLeave Set LeaveName=A.LeaveName,LeaveCount=A.LeaveCount,PayType=A.PayType,PerMonthAccr=A.PerMonthAccr
				From #tmpDetail A
				Where tblPayrollSettingLeave.PKID=A.PKID
				and A.PKID<>0
				And A.ModeForm=0
				And tblPayrollSettingLeave.FKSettingID=@PKID

				Update tblPayrollSettingWorkingDays Set DayNum=A.DayNum,IsOn=A.IsOn,StartTime=A.StartTime,EndTime=A.EndTime
				From #tmpWeekDays A
				Where tblPayrollSettingWorkingDays.PKID=A.PKID
				and A.PKID<>0
				And A.ModeForm=0
				And tblPayrollSettingWorkingDays.FKSettingID=@PKID
			End

			Declare @PKNewID Bigint=0
			Exec uspGetNewID 'tblPayrollSettingLeave','PKID',@PKNewID output
			Set @PKNewID=@PKNewID-1

			Update #tmpDetail Set @PKNewID=NewPKID=@PKNewID+1
			Where PKID=0 And ModeForm=0

			Insert Into tblPayrollSettingLeave(PKID,FKSettingID, LeaveName,LeaveCount,PayType,PerMonthAccr)
			Select NewPKID,@PKID, LeaveName,LeaveCount,PayType,PerMonthAccr
			From #tmpDetail Where PKID=0 And ModeForm=0

			Set @PKNewID=0
			Exec uspGetNewID 'tblPayrollSettingWorkingDays','PKID',@PKNewID output
			Set @PKNewID=@PKNewID-1

			Update #tmpWeekDays Set @PKNewID=NewPKID=@PKNewID+1
			Where PKID=0 And ModeForm=0

			Insert Into tblPayrollSettingWorkingDays(PKID,FKSettingID,DayNum,IsOn,StartTime,EndTime)
			Select NewPKID,@PKID,DayNum,IsOn,StartTime,EndTime
			From #tmpWeekDays Where PKID=0 And ModeForm=0



			
		End
			

	Select @Result as Result,@Msg as Msg,@PKID as PKID

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

