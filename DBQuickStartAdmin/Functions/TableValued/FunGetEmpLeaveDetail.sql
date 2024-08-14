CREATE FUNCTION [dbo].[FunGetEmpLeaveDetail]
(
	@FKEmpID		Bigint,
	@FKLeaveID		Bigint,
	@PayType		Varchar(50),
	@PerMonthAccr	Decimal(18,2),
	@LeaveCount		Decimal(18,2),	
	@FKCompanyID	BIgint,
	@JoinDate		Date,
	@YStartDate		Date,
	@YEndDate		Date,
	@OnDate			Date,
	@FKYearID		Bigint

)
RETURNS @returntable TABLE
(
	FKEmpID		Bigint,
	FKLeaveID	BIgint,	
	CFCount		Decimal(18,2),
	AccrCount	Decimal(18,2),
	TakenCount	Decimal(18,2),
	BalCount 	Decimal(18,2)
)
AS
BEGIN
	
	Declare @LeavaType	Varchar(50)=''
	Declare @CFCount		Decimal(18,2)=0
	Declare @AccrCount  Decimal(18,2)=0
	Declare @TakenCount	Decimal(18,2)=0
	Declare @BalCount 	Decimal(18,2)=0
	Declare @Month Bigint=0


	Select @TakenCount=Sum(LeaveCount) FRom tblLeaveRequest Where FKEmpID=@FKEmpID and FKLeaveID=@FKLeaveID and (ApproveStatus='Pending' Or ApproveStatus='Approved')
	And FromDate>=@YStartDate and ToDate<=@YEndDate
	Set @TakenCount=Isnull(@TakenCount,0)

	Select @CFCount=OpBal FRom tblEmployeeLeaveBalance Where FKEmpID=@FKEmpID And FKLeaveID=@FKLeaveID and FKYearID=@FKYearID
	Set @CFCount=Isnull(@CFCount,0)

	if(@PayType='Paid')
	Begin
			If(@JoinDate<@YStartDate)
			Begin
				Set @JoinDate=@YStartDate
			End
			If(@PerMonthAccr>0)
			Begin
				Set  @Month=DATEDIFF(Month,@JoinDate,@OnDate)

				Set @AccrCount=@Month*@PerMonthAccr
			End

			if(@AccrCount>@LeaveCount)
			Begin
				Set @AccrCount=@LeaveCount
			End

			Set @BalCount=@CFCount+@AccrCount-@TakenCount

	End

	 

	Insert Into @returntable
	Values(@FKEmpID,@FKLeaveID,@CFCount,@AccrCount,@TakenCount,@BalCount)



	RETURN
END
