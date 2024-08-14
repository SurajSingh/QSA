CREATE PROCEDURE [dbo].[uspGetRecentLog]
	@FKUserID		Bigint,
	@FKCompanyID	Bigint
AS
Begin
	Declare @UserType Varchar(50)

	Select @UserType=RoleType From tblUser Where PKUserID=@FKUserID
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	If(@UserType='Admin')
	Begin
			
		Select top 20 1 as Result,A.PKID,A.Operation,B.LoginID,dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.LogDate,@FKTimezoneID),'DateMonthName','D') as LogDate,dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.LogDate,@FKTimezoneID),@DateForStr,'T') as LogTime From tblUserLog A 
		Left Join tblUser B on A.FKUserID=B.PKUserID
		Where B.FKCompanyID=@FKCompanyID
		Order by A.LogDate Desc
	End

	
	Else
	Begin
		Select top 20 1 as Result,A.PKID,A.Operation,B.LoginID,dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.LogDate,@FKTimezoneID),'DateMonthName','D') as LogDate,dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.LogDate,@FKTimezoneID),@DateForStr,'T') as LogTime From tblUserLog A 
		Left Join tblUser B on A.FKUserID=B.PKUserID
		Where FKUserID=@FKUserID And Operation<>'Login' And Operation<>'Logout'
		Order by A.LogDate Desc
	End
End
