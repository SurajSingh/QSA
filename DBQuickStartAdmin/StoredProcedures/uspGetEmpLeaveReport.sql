CREATE PROCEDURE [dbo].[uspGetEmpLeaveReport]
	@FKCompanyID	Bigint,
	@FKEmpID		Bigint,
	@FKLeaveID		Bigint
AS
Begin
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID

	Declare 	
	@JoinDate		Date,
	@YStartDate		Date,
	@YEndDate		Date,
	@OnDate			Date,
	@FKYearID		Bigint,
	@PayType		Varchar(50),
	@PerMonthAccr		Decimal(18,4),
	@LeaveCount		    Decimal(18,4)

	Set @OnDate=dbo.fnGetUserDateTime(GETUTCDATE(),@FKTimezoneID)
	Select @FKYearID=PKID,@YStartDate=FromDate,@YEndDate=ToDate FRom tblFiscalYear where FKCompanyID=@FKCompanyID and IsActive=1
	
	Select @JoinDate=JoinDate FRom tblUser Where PKUserID=@FKEmpID


	Create table #tmpLeave(
	Id					Bigint Identity(1,1),
	FKLeaveID			Bigint,
	PayType				Varchar(50),
	PerMonthAccr		Decimal(18,4),
	LeaveCount		    Decimal(18,4)
	
	)

	Insert Into #tmpLeave
	Select A.PKID,A.PayType,A.PerMonthAccr,A.LeaveCount FRom tblPayrollSettingLeave A Inner JOin tblPayrollSetting B on A.FKSettingID=B.PKID 
	Where B.FKCompanyID=@FKCompanyID and (A.PKID=@FKLeaveID Or @FKLeaveID=0)

	Declare @start Bigint=1
	DEclare @end Bigint=0
	Select @end=max(Id) From #tmpLeave

	Create table #tmpLeaveReport(
	FKEmpID		Bigint,
	FKLeaveID	BIgint,	
	CFCount		Decimal(18,2),
	AccrCount	Decimal(18,2),
	TakenCount	Decimal(18,2),
	BalCount 	Decimal(18,2)
	
	)


	If(Isnull(@end,0)>0)
	Begin

		While @start<=@end
		Begin
			Select @FKLeaveID=FKLeaveID,@PayType=PayType,@LeaveCount=LeaveCount,@PerMonthAccr=PerMonthAccr FRom #tmpLeave Where Id=@start


			Insert Into #tmpLeaveReport
			Select FKEmpID,FKLeaveID,CFCount,AccrCount,TakenCount,BalCount FRom  dbo.FunGetEmpLeaveDetail(@FKEmpID,@FKLeaveID,@PayType,@PerMonthAccr,@LeaveCount,@FKCompanyID,@JoinDate,@YStartDate,@YEndDate,@OnDate,@FKYearID)

			Set @start=@start+1
		End

	End


	Select A.*,B.LeaveName,B.PayType,C.LoginID,C.FName+' '+C.LName as EmpName FRom #tmpLeaveReport A
	Inner JOin tblPayrollSettingLeave B on A.FKLeaveID=B.PKID
	Inner JOin tblUser C on A.FKEmpID=C.PKUserID


End