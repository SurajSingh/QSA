CREATE PROCEDURE [dbo].[uspDashboardGetTopTasks]
	@FKUserID Bigint,
	@FKCompanyID Bigint,
	@RoleType Varchar(20),
	@StartDate Date,
	@EndDate Date 
AS
Begin
	--Top 10 Task
	Select Top 10 B.TaskCode+':'+B.TaskName as TaskCode,Sum(A.Hrs) as Hrs,Sum(A.Hrs*A.TBillRate) as BillAmount,Sum(A.Hrs*A.TCostRate) as TCostRate From tblTimeSheet a
	Left Join tblTask B on A.FKTaskID=B.PKID
	Where a.FKCompanyID=@FKCompanyID  and a.ApproveStatus='Approved'
	and A.TaskDate Between @StartDate and @EndDate
	And (A.FKEmpID=@FKUserID Or @RoleType='Admin')
	Group By B.TaskCode+':'+B.TaskName
	Order By Sum(A.TBillRate*A.Hrs) Desc


	Declare @TotalHours Decimal(18,2),@BillableHours Decimal(18,2),@NonBillableHours Decimal(18,4),@BillableAmount Decimal(18,4)

	Select @BillableHours=Sum(A.Hrs),@BillableAmount=Sum(A.TBillRate*A.Hrs) From tblTimeSheet a	
	Where a.FKCompanyID=@FKCompanyID  and a.ApproveStatus='Approved'
	and A.TaskDate Between @StartDate and @EndDate
	And (A.FKEmpID=@FKUserID Or @RoleType='Admin')
	And A.IsBillable=1
	Select @NonBillableHours=Sum(A.Hrs) From tblTimeSheet a	
	Where a.FKCompanyID=@FKCompanyID  and a.ApproveStatus='Approved'
	and A.TaskDate Between @StartDate and @EndDate
	And (A.FKEmpID=@FKUserID Or @RoleType='Admin')
	And A.IsBillable=0

	Set @BillableHours=Isnull(@BillableHours,0)
	Set @NonBillableHours=Isnull(@NonBillableHours,0)
	Set @BillableAmount=Isnull(@BillableAmount,0)
	Set @TotalHours=@BillableHours+@NonBillableHours

	Select @TotalHours as TotalHours,@BillableHours as BillableHours,@NonBillableHours as NonBillableHours,@BillableAmount as BillableAmount

	
	

End