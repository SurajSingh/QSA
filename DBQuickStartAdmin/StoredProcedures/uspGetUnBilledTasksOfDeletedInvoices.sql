CREATE PROCEDURE [dbo].[uspGetUnBilledTasksOfDeletedInvoices]
	@FKCompanyID	Bigint,
	@PKID			Bigint,
	@FKProjectID	Bigint,
	@InvFromDate DATE,
	@InvToDate DATE
AS
Begin
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	if(@InvFromDate = '1-1-1900' And @InvToDate = '1-1-1900')
	Begin
		Select A.PKID, dbo.fnGetDateFormat(A.TaskDate,@DateForStr,'D') as TaskDate, A.FKTaskID, A.FKEmpID, A.FKProjectID, A.Hrs, 
		A.Description, A.IsBillable, 
		A.Memo, A.TBHours, A.TCostRate, A.TBillRate, Isnull(A.FKAssignLogID,0) as FKAssignLogID, Isnull(A.FKSubmitToID,0) as FKSubmitToID, A.ApproveStatus, 
		dbo.fnGetDateFormat(A.ApproveDate,@DateForStr,'D') as ApproveDate, A.IsBilled, Isnull(A.FKInvoiceID,0) as FKInvoiceID, A.TaskStatus,	
		D.TaskCode+':'+D.TaskName as TaskName,
		Emp.FName,Emp.LName,emp.LoginID
		From tblTimeSheet A
		Inner Join tblTask D on A.FKTaskID=D.PKID
		Left Join tblUser Emp on A.FKEmpID=emp.PKUserID
		where A.FKCompanyID=@FKCompanyID
		And A.FKProjectID=@FKProjectID
		and A.IsBillable=1
		And A.ApproveStatus='Approved'
		And  ((A.IsBilled=0 Or A.FKInvoiceID=0) or (A.IsBilled=1 and  A.FKInvoiceID 
in (select PKID from tblInvoice where PKID = A.FKInvoiceID and IsDeleted=1)) )-- or A.FKInvoiceID IS NOT Null) 
		--(A.FKInvoiceID=@PKID and A.FKInvoiceID<>0) Modified By Nilesh to get the task which having invoice number
		--but not billed. This is because if we delete the invoice isbilled flag reset to 0 but invoice number remain same.
		Order By A.TaskDate,A.FKEmpID
	End 
	else Begin
		Select A.PKID, dbo.fnGetDateFormat(A.TaskDate,@DateForStr,'D') as TaskDate, A.FKTaskID, A.FKEmpID, A.FKProjectID, A.Hrs, 
		A.Description, A.IsBillable, 
		A.Memo, A.TBHours, A.TCostRate, A.TBillRate, Isnull(A.FKAssignLogID,0) as FKAssignLogID, Isnull(A.FKSubmitToID,0) as FKSubmitToID, A.ApproveStatus, 
		dbo.fnGetDateFormat(A.ApproveDate,@DateForStr,'D') as ApproveDate, A.IsBilled, Isnull(A.FKInvoiceID,0) as FKInvoiceID, A.TaskStatus,	
		D.TaskCode+':'+D.TaskName as TaskName,
		Emp.FName,Emp.LName,emp.LoginID
		From tblTimeSheet A
		Inner Join tblTask D on A.FKTaskID=D.PKID
		Left Join tblUser Emp on A.FKEmpID=emp.PKUserID
		where A.FKCompanyID=@FKCompanyID
		And A.FKProjectID=@FKProjectID
		and A.IsBillable=1
		And A.ApproveStatus='Approved'
		And  ((A.IsBilled=0 Or A.FKInvoiceID=@PKID) or (A.IsBilled=1 and  A.FKInvoiceID 
in (select PKID from tblInvoice where PKID = A.FKInvoiceID and IsDeleted=1)) )
		--(A.FKInvoiceID=@PKID and A.FKInvoiceID<>0) Modified By Nilesh to get the task which having invoice number
		--but not billed. This is because if we delete the invoice isbilled flag reset to 0 but invoice number remain same.
		And A.TaskDate BETWEEN @InvFromDate And @InvToDate
		Order By A.TaskDate,A.FKEmpID
	End
End
