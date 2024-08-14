CREATE PROCEDURE [dbo].[uspGetGroups]
	@PKID  Bigint,
	@FKDtlID Bigint,
	@RecType Varchar(50),
	@FKCompanyID Bigint
AS
Begin
	
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID

	If(@RecType='Employee')
	Begin
			Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.GroupName,A.Description,dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,'D') as CreationDate,B.FName+' '+B.LName as CreatedByName,(Select count(*) From tblEmpGroupDetail where FKID=A.PKID) as ChildCount
			From tblEmpGroup A 
			Left Join tblUser B on A.FKCreatedBy=B.PKUserID
			Where A.FKCompanyID=@FKCompanyID
			And (A.PKID=@PKID Or @PKID=0)	
			And (@FKDtlID=0 OR @FKDtlID in (Select FKEmpID From tblEmpGroupDetail where FKID=A.PKID))

			If(@PKID<>0)
			Begin
				Select A.FKEmpID,B.FName+' '+B.LName as EmpName,B.LoginID From tblEmpGroupDetail A Inner Join tblUser B on A.FKEmpID=B.PKUserID
				Where A.FKID=@PKID
				Order By B.FName+' '+B.LName
			End

	End
	Else If(@RecType='Client')
	Begin
			Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.GroupName,A.Description,dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,'D') as CreationDate,B.FName+' '+B.LName as CreatedByName,
			(Select count(*) From tblClientGroupDetail where FKID=A.PKID) as ChildCount
			From tblClientGroup A 
			Left Join tblUser B on A.FKCreatedBy=B.PKUserID
			Where A.FKCompanyID=@FKCompanyID
			And (A.PKID=@PKID Or @PKID=0)	
			And (@FKDtlID=0 OR @FKDtlID in (Select FKClientID From tblClientGroupDetail where FKID=A.PKID))
			If(@PKID<>0)
			Begin
				Select A.FKClientID,B.Company,B.Code From tblClientGroupDetail A Inner Join tblClient B on A.FKClientID=B.PKID
				Where A.FKID=@PKID
				Order By B.Company
			End

	End
	Else If(@RecType='Project')
	Begin
			Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.GroupName,A.Description,dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,'D') as CreationDate,B.FName+' '+B.LName as CreatedByName,
			(Select count(*) From tblProjectGroupDetail where FKID=A.PKID) as ChildCount
			From tblProjectGroup A 
			Left Join tblUser B on A.FKCreatedBy=B.PKUserID
			Where A.FKCompanyID=@FKCompanyID
			And (A.PKID=@PKID Or @PKID=0)	
			And (@FKDtlID=0 OR @FKDtlID in (Select FKProjectID From tblProjectGroupDetail where FKID=A.PKID))

			If(@PKID<>0)
			Begin
				Select A.FKProjectID,B.ProjectName,B.ProjectCode From tblProjectGroupDetail A Inner Join tblProject B on A.FKProjectID=B.PKID
				Where A.FKID=@PKID
				Order By B.ProjectName
			End

	End
	Else If(@RecType='Expenses')
	Begin
			Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.GroupName,A.Description,dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,'D') as CreationDate,B.FName+' '+B.LName as CreatedByName,
			(Select count(*) From tblExpenseGroupDetail where FKID=A.PKID) as ChildCount
			From tblExpenseGroup A 
			Left Join tblUser B on A.FKCreatedBy=B.PKUserID
			Where A.FKCompanyID=@FKCompanyID
			And (A.PKID=@PKID Or @PKID=0)	
			And (@FKDtlID=0 OR @FKDtlID in (Select FKExpID From tblExpenseGroupDetail where FKID=A.PKID))
			If(@PKID<>0)
			Begin
				Select A.FKExpID,B.TaskCode+':'+TaskName as TaskCodeName From tblExpenseGroupDetail A Inner Join tblTask B on A.FKExpID=B.PKID
				Where A.FKID=@PKID
				Order By B.TaskCode+' '+TaskName
			End

	End

End
