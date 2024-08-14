CREATE PROCEDURE [dbo].[uspGetProjectModule]
	@PKID			BIgint,
	@FKCompanyID	Bigint,
	@FKParentID		Bigint,
	@FKProjectID	Bigint,
	@RecType		Varchar(50)
AS
Begin
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Declare @Downline NVarchar(max)=''
	If(@RecType='TaskSearch' and @FKParentID<>0)
	Begin
		Select @Downline=DownLine From tblProjectModule where PKID=@FKParentID
		Set @FKParentID=0
	End

	IF(@RecType='TaskSearch')
	Begin
		Set @RecType='Task'
	End
	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
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
	And (@PKID=0 Or A.PKID=@PKID)
	And (@FKProjectID=0 Or A.FKProjectID=@FKProjectID)
	And (@FKParentID=0 or A.FKParentID=@FKParentID)
	And (@RecType='' Or A.RecType=@RecType)
	And (@Downline='' Or '-'+A.DownLine+'-' Like '%-'+@Downline+'-%')
	Order by A.SNo

	IF(@PKID<>0)
	Begin
		Select 1 as Result,A.PKID, dbo.fnGetDateFormat(A.AssignDate,@DateForStr,'D') as AssignDate, 
	A.FKTaskID, A.FKEmpID, A.FKProjectID, A.BHrs, A.TimeTaken, A.Description, A.CurrentStatus, A.FKManagerID, A.FKCreatedBy,A.Remark,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,'D') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,'D') as ModificationDate, 	
	B.LoginID,B.FName+' '+B.LName as EmpName,C.ProjectCode,C.ProjectName,
	D.TaskCode+':'+D.TaskName as TaskName,C1.Code As ClientCode,C1.Company as ClientName,
	Isnull(U1.FName,'') as CreatedByName,Isnull(U2.FName,'') as ModifiedByName,
	Isnull(U.FName+' '+U.LName,'') as ManagerName,(Select count(*) From tbltimesheet where FKAssignLogID=A.PKID) as LogCount	
	From tblTaskAssignment A
	Inner Join tblUser B on A.FKEmpID=B.PKUserID
	Inner Join tblProject C on A.FKProjectID=C.PKID
	Inner Join tblTask D on A.FKTaskID=D.PKID
	Left Join tblClient C1 on C.FKClientID=C1.PKID	
	Left Join tblUser U on A.FKManagerID=U.PKUserID
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID	
	Where A.BStatus=1 And (A.FKProjectForecastingID=@PKID)
	
	End


End
