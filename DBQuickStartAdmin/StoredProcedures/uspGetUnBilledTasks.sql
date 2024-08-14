CREATE PROCEDURE [dbo].[uspGetUnBilledTasks]	
	@PKID			Bigint,
	@FKProjectID	Bigint,
	@FKCompanyID	Bigint,
	@InvFromDate DATE,
	@InvToDate DATE
AS
Begin
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	if(@InvFromDate = '1900-01-01' And @InvToDate = '1900-01-01')
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
		And  (A.IsBilled=0 Or A.FKInvoiceID=@PKID) or (A.IsBilled=1 and  A.FKInvoiceID 
			in (select PKID from tblInvoice I where I.PKID = A.FKInvoiceID and I.IsDeleted=1)) 
		Order By A.TaskDate,A.FKEmpID
	End 
	else Begin
		if(@InvToDate = '1-1-2000')Begin
		set @InvToDate = GETDATE();
		End
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
		And  (A.IsBilled=0 Or A.FKInvoiceID=@PKID) or (A.IsBilled=1 and  A.FKInvoiceID 
			in (select PKID from tblInvoice I where I.PKID = A.FKInvoiceID and I.IsDeleted=1)) 
		And A.TaskDate BETWEEN @InvFromDate And @InvToDate
		Order By A.TaskDate,A.FKEmpID
	End
End
