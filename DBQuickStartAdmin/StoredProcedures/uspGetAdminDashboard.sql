CREATE PROCEDURE [dbo].[uspGetAdminDashboard]	
	@FKUserID Bigint,
	@FKCompanyID Bigint,
	@RoleType Varchar(20)
AS
Begin
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Declare @Today Date
	Declare @Year Varchar(50)

	


	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	Set @Today=dbo.fnGetUserDateTime(GETUTCDATE(),@FKTimezoneID)
	Set @Year=YEAR(@Today)

	Declare @StartDate Date=convert(date,@Year+'/01/01')
	Declare @EndDate Date=convert(date,@Year+'/12/31')

	--Billing Detail
	If(@RoleType='Admin')
	Begin
	Select          
	SUBSTRING('Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec ', (Item * 4) - 3, 3) as 'Month',      
	Isnull((
	Select Sum(TCostRate*Hrs) From tblTimeSheet where FKCompanyID=@FKCompanyID 
	and ApproveStatus='Approved' 
	and TaskDate between DATEADD(m, Convert(Int,A.Item) - 1, DATEADD(yyyy, @Year - 1900, 0))  And DATEADD(d, -1, DATEADD(m, Convert(Int,A.Item), DATEADD(yyyy, @Year - 1900, 0))	
	) )  ,0)  
	as CostAmount  ,
	Isnull((
	Select Sum(TCostRate*Hrs) From tblTimeSheet where FKCompanyID=@FKCompanyID 
	and ApproveStatus='Approved' And IsBillable=1  
	and TaskDate between DATEADD(m, Convert(Int,A.Item) - 1, DATEADD(yyyy, @Year - 1900, 0))  And DATEADD(d, -1, DATEADD(m, Convert(Int,A.Item), DATEADD(yyyy, @Year - 1900, 0))	
	) )  ,0)  
	as BillAmount,
	Isnull((
	Select Sum(TCostRate*Hrs) From tblTimeSheet where FKCompanyID=@FKCompanyID 
	and ApproveStatus='Approved' And IsBilled=1  
	and TaskDate between DATEADD(m, Convert(Int,A.Item) - 1, DATEADD(yyyy, @Year - 1900, 0))  And DATEADD(d, -1, DATEADD(m, Convert(Int,A.Item), DATEADD(yyyy, @Year - 1900, 0))	
	) )  ,0)  
	as BilledAmount
	from dbo.FunSplitString('01,02,03,04,05,06,07,08,09,10,11,12',',') a 
	End
	Else
	Begin
		Select 0 where 1=2
	End

	--Top 10 Employee
	Select Top 10 B.LoginID,Sum(A.TBillRate*A.Hrs) as Amount,sum(A.Hrs) as Hrs From tblTimeSheet a
	Left Join tblUser B on A.FKEmpID=B.PKUserID
	Where a.FKCompanyID=@FKCompanyID and a.IsBillable=1 and a.ApproveStatus='Approved'
	and A.TaskDate Between @StartDate and @EndDate
	And (A.FKEmpID=@FKUserID Or @RoleType='Admin')
	Group By B.LoginID
	Order By Sum(A.TBillRate*A.Hrs) Desc

	
	


	
	--Monthlly Time
	Select          
	SUBSTRING('Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec ', (Item * 4) - 3, 3) as 'Month',      
	Isnull((
	Select Sum(Hrs) From tblTimeSheet where FKCompanyID=@FKCompanyID And (FKEmpID=@FKUserID Or @RoleType='Admin')
	and ApproveStatus='Approved' 
	and TaskDate between DATEADD(m, Convert(Int,A.Item) - 1, DATEADD(yyyy, @Year - 1900, 0))  And DATEADD(d, -1, DATEADD(m, Convert(Int,A.Item), DATEADD(yyyy, @Year - 1900, 0))	
	) )  ,0)  
	as Hrs 
	from dbo.FunSplitString('01,02,03,04,05,06,07,08,09,10,11,12',',') a 

	Select A.PKID,dbo.fnGetDateFormat(A.FromDate,@DateForStr,'D') as FromDate,dbo.fnGetDateFormat(A.FromTime,@DateForStr,'T') as FromTime,C.ProjectName,'Schedule' as RecType
	From 
	tblClientScheduleDetail B inner join
	tblClientSchedule A on B.FKID=A.PKID
	Inner Join tblProject C on A.FKProjectID=C.PKID	
	Where B.FKEmpID=@FKUserID and A.FromDate>=@Today
	Union All
	Select A.PKID, dbo.fnGetDateFormat(A.OnDate,@DateForStr,'D') as FromDate,dbo.fnGetDateFormat(A.FromTime,@DateForStr,'T') as FromTime,A.CutomerName as ProjectName,'Appointment' as RecType
	From tblAppoinment A
	Where A.FKEmpID=@FKUserID


	If(@RoleType='Admin')
	Begin
		Select A.PKID,A.InvoiceID,dbo.fnGetDateFormat(A.InvDate,@DateForStr,'D') as InvDate, A.NetAmount,A.NetDueAmount,CM.Symbol,C.ProjectCode,C.ProjectName
		From tblInvoice A	
		Inner Join tblProject C on A.FKProjectID=C.PKID	
		Left Join tblClient C1 on C.FKClientID=C1.PKID	
		Left JOin tblCurrencyMaster	CM on A.FKCurrencyID=CM.PKCurrencyID
	End
	Else
	Begin
		Select 0 where 1=2
	End
	




End
