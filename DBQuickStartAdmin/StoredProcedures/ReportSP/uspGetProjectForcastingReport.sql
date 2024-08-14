CREATE PROCEDURE [dbo].[uspGetProjectForcastingReport]
	@PKID	Bigint,
	@FKCompanyID BIgint,
	@RecType		Varchar(50)
AS
Begin

	Declare @FKTimezoneID Bigint	
	Declare @DateForStr Varchar(50)
	Declare @Downline NVarchar(max)=''
	
	IF(@RecType='TaskSearch')
	Begin
		Set @RecType='Task'
	End
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.PKID,A.FKClientID,A.ProjectCode,A.ProjectName,Isnull(A.FKManagerID,0) as FKManagerID,
	Isnull(A.FKContractTypeID,0) as FKContractTypeID,A.ProjectStatus,A.ContractAmt,A.ExpAmt,A.ServiceAmt,A.BudgetedHours,
	dbo.fnGetDateFormat(A.Startdate,@DateForStr,'D') as Startdate,dbo.fnGetDateFormat(A.DueDate,@DateForStr,'D') as DueDate,
	A.CompletePercent,A.PONo,A.Remark,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,'D') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,'D') as ModificationDate, 	
	Isnull(A1.FName,'') as ManagerName,
	C.Code as ClientID,C.Company as ClientCompany,C.CPerson,
	Isnull(U1.FName,'') as CreatedByName,Isnull(U2.FName,'') as ModifiedByName,
	(a.BudgetedHours*a.CompletePercent/100) as AdjBudgetHrs,
	Isnull((Select sum(Hrs) From tblTimeSheet where FKProjectID=A.PKID and ApproveStatus='Approved'),0) as ActualHrs,
	Isnull((Select sum(Hrs*TCostRate) From tblTimeSheet where FKProjectID=A.PKID and ApproveStatus='Approved'),0) as CostToCompany,
	Isnull(CT.ContractType,'') as ContractType,
	Isnull((Select Sum(NetAmount) From tblInvoice where FKProjectID=A.PKID),0) BilledAmount,
	(Select count(*) from tblProjectModule where FKProjectID=A.PKID and RecType='Task') as NoOfTask,
	(Select count(*) from tblProjectModule where FKProjectID=A.PKID and RecType='Module' and Isnull(FKParentID,0)=0) as NoOfModule,
	Isnull((Select Sum(EstHrs) from tblProjectModule where FKProjectID=A.PKID and RecType='Task'),0)	 as EstHrs
	From tblProject A	
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Left Join tblUser A1 on A.FKManagerID=A1.PKUserID
	Left Join tblClient C on A.FKClientID=C.PKID	
	Left Join tblContractType CT on A.FKContractTypeID=CT.PKID
	Where A.BStatus=1 And (A.PKID=@PKID or @PKID=0)	
	And (A.FKCompanyID=@FKCompanyID)	
	

	If(@RecType='Task')
	Begin

	Select 1 as Result,A.PKID,A.SNo,A.FKProjectID,A.ModuleName,A.ModuleDesc,Isnull(A.FKParentID,0) as FKParentID,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,'D') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,'D') as ModificationDate, 
	Isnull(A.FKTaskID,0) as FKTaskID,dbo.fnGetDateFormat(A.EstStartDate,@DateForStr,'D') as EstStartDate,
	dbo.fnGetDateFormat(A.EstEndDate,@DateForStr,'D') as EstEndDate,
	dbo.fnGetDateFormat(A.StartDate,@DateForStr,'D') as StartDate,
	dbo.fnGetDateFormat(A.EndDate,@DateForStr,'D') as EndDate,
	A.EstHrs,A.CompletePer,A.TaskStatus,Isnull(T.TaskCode,'') as TaskCode,Isnull(T.TaskName,'') as TaskName,A.RecType,
	Isnull(U1.FName,'') as CreatedByName,Isnull(U2.FName,'') as ModifiedByName,
	B.ModuleName as ParentName,
	P.ProjectCode,P.ProjectName,
	dbo.FunGetProjectModuleParent(A.PKID,A.FKProjectID,A.DownLine) as ParentList,
	dbo.FunGetProjectModuleEmp(A.PKID) as AssignedEmp,
	(Select count(*) from tblProjectModule where FKParentID=A.PKID and RecType='Task') as NoOfTask,
	(Select count(*) from tblProjectModule where FKParentID=A.PKID and RecType='Module') as NoOfModule,
	Isnull((Select Sum(T2.Hrs) FRom tblTaskAssignment T1 inner Join tblTimeSheet T2 on T1.PKID=T2.FKAssignLogID where T1.FKProjectForecastingID=A.PKID),0) as ActualHours
	From tblProjectModule A
	Left Join tblProjectModule B on A.FKParentID=B.PKID
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Left Join tblProject P on A.FKProjectID=P.PKID
	Left Join tblTask T on A.FKTaskID=T.PKID
	Where A.FKCompanyID=@FKCompanyID	
	And (@PKID=0 Or A.FKProjectID=@PKID)
	And (@RecType='' Or A.RecType=@RecType)
	And (@Downline='' Or '-'+A.DownLine+'-' Like '%-'+@Downline+'-%')
	Order by A.SNo
	End
	Else
	Begin
		IF(@RecType='Allocation')
		Begin
			Set @RecType='Task'
		End

		Select 1 as Result,A.PKID,A.SNo,A.FKProjectID,A.ModuleName,A.ModuleDesc,Isnull(A.FKParentID,0) as FKParentID,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,'D') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,'D') as ModificationDate, 
	Isnull(A.FKTaskID,0) as FKTaskID,dbo.fnGetDateFormat(A.EstStartDate,@DateForStr,'D') as EstStartDate,
	dbo.fnGetDateFormat(A.EstEndDate,@DateForStr,'D') as EstEndDate,
	dbo.fnGetDateFormat(A.StartDate,@DateForStr,'D') as StartDate,
	dbo.fnGetDateFormat(A.EndDate,@DateForStr,'D') as EndDate,
	A.EstHrs,A.CompletePer,A.TaskStatus,Isnull(T.TaskCode,'') as TaskCode,Isnull(T.TaskName,'') as TaskName,A.RecType,
	Isnull(U1.FName,'') as CreatedByName,Isnull(U2.FName,'') as ModifiedByName,
	B.ModuleName as ParentName,
	P.ProjectCode,P.ProjectName,
	dbo.FunGetProjectModuleParent(A.PKID,A.FKProjectID,A.DownLine) as ParentList,
	dbo.FunGetProjectModuleEmp(A.PKID) as AssignedEmp,
	(Select count(*) from tblProjectModule where FKParentID=A.PKID and RecType='Task') as NoOfTask,
	(Select count(*) from tblProjectModule where FKParentID=A.PKID and RecType='Module') as NoOfModule,
	Isnull((Select Sum(T2.Hrs) FRom tblTaskAssignment T1 inner Join tblTimeSheet T2 on T1.PKID=T2.FKAssignLogID where T1.FKProjectForecastingID=A.PKID),0) as ActualHours,
	C.TaskDate,C.LoginID as EmpID,C.EmpName,C.Hrs,Isnull(C.FKProjectForecastingID,0) as FKProjectForecastingID
	From tblProjectModule A
	Left Join tblProjectModule B on A.FKParentID=B.PKID
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Left Join tblProject P on A.FKProjectID=P.PKID
	Left Join tblTask T on A.FKTaskID=T.PKID
	Full Join
	(Select T1.FKProjectForecastingID,T3.TaskDate,T3.Hrs,T1.FKTaskID,U.LoginID,U.FName+' '+U.LName as EmpName From 	 tblTaskAssignment T1	
	Left Join tblTimeSheet T3 on T3.FKAssignLogID=T1.PKID
	Left Join tblUser U on T3.FKEmpID=U.PKUserID
	) C on C.FKProjectForecastingID=A.PKID And C.FKTaskID=A.FKTaskID

	Where A.FKCompanyID=@FKCompanyID	
	And (@PKID=0 Or A.FKProjectID=@PKID)
	And (@RecType='' Or A.RecType=@RecType)
	And (@Downline='' Or '-'+A.DownLine+'-' Like '%-'+@Downline+'-%')
	Order by A.SNo

	End







End
