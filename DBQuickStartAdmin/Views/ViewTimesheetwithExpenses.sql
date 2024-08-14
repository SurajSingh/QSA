CREATE VIEW [dbo].[ViewTimesheetwithExpenses]
	AS 

	
	Select
	A.PKID, A.TaskDate, A.FKTaskID, A.FKEmpID, A.FKProjectID,C.FKClientID, A.Hrs, 
	A.Description, A.IsBillable, 0 as MU,0 as IsReimb,
	A.Memo, A.TBHours, A.TCostRate, A.TBillRate, 
	A.Hrs*A.TBillRate as BillAmt,
	A.Hrs*A.TCostRate as CostAmt,
	A.Hrs*A.TBillRate as Amount,
	A.TBHours*A.TBillRate as BudAmt,
	A.Hrs*A.TBillRate as ServiceAmt,
	0 as ExpAmt,
	Case When A.IsBillable=1 then A.Hrs Else 0 End as BillHrs,
	Case When A.IsBillable=0 then A.Hrs Else 0 End as UnBillHrs,
	Isnull(A.FKSubmitToID,0) as FKSubmitToID,
	Isnull(C.FKManagerID,0) as FKManagerID, 
	A.ApproveStatus, 
	A.ApproveDate, 
	A.IsBilled, Isnull(A.FKInvoiceID,0) as FKInvoiceID, 
	A.TaskStatus,
	C.ProjectCode,C.ProjectName,	
	D.TaskCode+':'+D.TaskName as TaskName,D.Description as TaskDescription,D.BHours,C1.Code As ClientCode,C1.Company as ClientName,	
	Isnull(U.FName,'') as SubmitToName,
	Isnull(U3.FName,'') as ApproveByName,
	Emp.FName+' '+Emp.LName as EmpName,emp.LoginID,
	U4.FName+' '+U4.LName as ManagerName,
	'Task' as TType
	From tblTimeSheet A	
	Inner Join tblProject C on A.FKProjectID=C.PKID
	Inner Join tblTask D on A.FKTaskID=D.PKID
	Left Join tblClient C1 on C.FKClientID=C1.PKID	
	Left Join tblUser Emp on A.FKEmpID=emp.PKUserID
	Left Join tblUser U on A.FKSubmitToID=U.PKUserID	
	Left Join tblUser U3 on A.FKApproveByID=U3.PKUserID	
	Left Join tblUser U4 on C.FKManagerID=U4.PKUserID
	Where A.BStatus=1 And Emp.BStatus=1 
	Union All
	Select
	
	A.PKID, A.TaskDate, A.FKTaskID, A.FKEmpID, A.FKProjectID,C.FKClientID, A.Unit as Hrs, 
	A.Description, A.IsBillable,A.MU,A.IsReimb, 
	A.Memo, A.Unit as TBHours, A.TCostRate, 0 as TBillRate, 
	A.Unit*A.TCostRate as BillAmt,
	A.Unit*A.TCostRate as CostAmt,
	A.Amount,	
	A.Unit*A.TCostRate as BudAmt,
	0 as ServiceAmt,
	A.Amount as ExpAmt,
	Case When A.IsBillable=1 then A.Unit Else 0 End as BillHrs,
	Case When A.IsBillable=0 then A.Unit Else 0 End as UnBillHrs,
	0 as FKSubmitToID,
	Isnull(C.FKManagerID,0) as FKManagerID, 
	A.ApproveStatus, 
	A.ApproveDate, 
	A.IsBilled, Isnull(A.FKInvoiceID,0) as FKInvoiceID, 
	a.ApproveStatus as TaskStatus,
	C.ProjectCode,C.ProjectName,	
	D.TaskCode+':'+D.TaskName as TaskName,D.Description as TaskDescription,D.BHours,C1.Code As ClientCode,C1.Company as ClientName,	
	Isnull(U3.FName,'') as SubmitToName,
	Isnull(U3.FName,'') as ApproveByName,
	Emp.FName+' '+Emp.LName as EmpName,emp.LoginID,
	U4.FName+' '+U4.LName as ManagerName,
	'Expenses' as TType
	From tblExpensesLog A	
	Inner Join tblProject C on A.FKProjectID=C.PKID
	Inner Join tblTask D on A.FKTaskID=D.PKID
	Left Join tblClient C1 on C.FKClientID=C1.PKID	
	Left Join tblUser Emp on A.FKEmpID=emp.PKUserID
	Left Join tblUser U3 on A.FKApproveByID=U3.PKUserID	
	Left Join tblUser U4 on C.FKManagerID=U4.PKUserID
	Where A.BStatus=1 And Emp.BStatus=1 

