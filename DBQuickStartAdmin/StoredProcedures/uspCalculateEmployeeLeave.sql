CREATE PROCEDURE [dbo].[uspCalculateEmployeeLeave]
	@FKLeaveID	Bigint,
	@FKEmpID	Bigint,
	@FromDate	Date,
	@NoOfDays	Decimal(18,4),
	@FKCompanyID	Bigint
AS
Begin
	
	Declare @Result Bigint =1
	Declare @Msg Varchar(200)=''
	Declare @Count Bigint=0
	
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID

	Declare 	
	@ToDate		Date,
	@JoinDate		Date,
	@YStartDate		Date,
	@YEndDate		Date,
	@OnDate			Date,
	@FKYearID		Bigint,
	@LeaveRule		Bigint,
	@PayType		Varchar(50),
	@PerMonthAccr	Decimal(18,4),
	@LeaveCount		Decimal(18,4),
	@BalCount		Decimal(18,4)

	Declare @WeekDayNum Bigint
	


	Set @OnDate=dbo.fnGetUserDateTime(GETUTCDATE(),@FKTimezoneID)
	Select @FKYearID=PKID,@YStartDate=FromDate,@YEndDate=ToDate FRom tblFiscalYear where FKCompanyID=@FKCompanyID and IsActive=1
	
	Select @JoinDate=JoinDate FRom tblUser Where PKUserID=@FKEmpID

	Select @PayType=PayType,@LeaveCount=LeaveCount,@PerMonthAccr=PerMonthAccr FRom tblPayrollSettingLeave where PKID=@FKLeaveID


	Select @BalCount=BalCount FRom  dbo.FunGetEmpLeaveDetail(@FKEmpID,@FKLeaveID,@PayType,@PerMonthAccr,@LeaveCount,@FKCompanyID,@JoinDate,@YStartDate,@YEndDate,@OnDate,@FKYearID)


	Select @Count=COUNT(*) FRom tblHoliday Where FKCompanyID=@FKCompanyID and HolidayDate=@FromDate

	IF(@Count>0)
	Begin
		Set @Result=0
		Select @Msg=HolidayName FRom tblHoliday Where FKCompanyID=@FKCompanyID and HolidayDate=@FromDate
		Set @Msg='Holiday '+@Msg+' exists on '+dbo.fnGetDateFormat(@FromDate,@DateForStr,'D')
	End

	If(@Result=1)
	Begin
		SELECT @WeekDayNum=DATEPART(dw,@FromDate)

		Select @Count=COUNT(*) From tblPayrollSettingWorkingDays a 
		Inner JOin tblPayrollSetting B on A.FKSettingID=B.PKID 
		Where A.DayNum=@WeekDayNum and A.IsOn=1 and B.FKCompanyID=@FKCompanyID

		If(@Count=0)
		Begin
			Set @Result=0
			Set @Msg=dbo.fnGetDateFormat(@FromDate,@DateForStr,'D')+' is non-working day'
		End

	End

	Declare @i Bigint=1
	Declare @TempDate Date

	If(@Result=1 And @PayType='Paid')
	Begin
		IF(@BalCount<@NoOfDays)
		Begin
			Set @NoOfDays=@BalCount
		End

		If(@NoOfDays=0)
		Begin
			Set @Result=0
			Set @Msg='Please select another leave type. Your paid leave balance is 0'
		End

	End


	If(@Result=1)
	Begin
		

		Select @LeaveRule=LeaveRule FRom tblPayrollSetting Where FKCompanyID=@FKCompanyID
		IF(@NoOfDays<=1)
		Begin
			Set @ToDate=@FromDate
		End
		Else
		Begin
			Set @ToDate=@FromDate
			While @i<@NoOfDays
			Begin
				Set @ToDate=DateAdd(DAY,1,@ToDate)
				
				SELECT @WeekDayNum=DATEPART(dw,@ToDate)

				Select @Count=COUNT(*) From tblPayrollSettingWorkingDays a 
				Inner JOin tblPayrollSetting B on A.FKSettingID=B.PKID 
				Where A.DayNum=@WeekDayNum and A.IsOn=1 and B.FKCompanyID=@FKCompanyID

				If(@Count=0)
				Begin
					if(@LeaveRule=1)
					Begin
						Set @i=@i-1
					End
				End
				Else
				Begin
					Select @Count=COUNT(*) FRom tblHoliday Where FKCompanyID=@FKCompanyID and HolidayDate=@ToDate
					If(@Count>0)
					Begin
						IF(@LeaveRule=1)
						Begin
							Set @i=@i-1
						End
					End
				End

				Set @i=@i+1
			End
		End


	End




Select @Result as Result,@Msg as Msg,dbo.fnGetDateFormat(@ToDate,@DateForStr,'D') as ToDate,@NoOfDays as  NoOfDays

End
