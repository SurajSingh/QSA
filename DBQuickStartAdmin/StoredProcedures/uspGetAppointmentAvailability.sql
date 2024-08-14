CREATE PROCEDURE [dbo].[uspGetAppointmentAvailability]
	@DateWise		Bit,
	@FromDate		Date,
	@ToDate			Date,
	@PKID			Bigint,
	@FKCompanyID	Bigint,
	@FKEmpID		BIgint,	
	@RecType		Varchar(50)
AS
Begin
	Declare @FKTimezoneID Bigint	
	Declare @DateForStr Varchar(50)
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	Select 1 as Result,A.PKID,A.FKEmpID,dbo.fnGetDateFormat(A.OnDate,@DateForStr,'D') as OnDate,
	dbo.fnGetDateFormat(A.FromTime,@DateForStr,'T') as FromTime,dbo.fnGetDateFormat(A.ToTime,@DateForStr,'T') as ToTime,
	A.AMinutes,A.IsUsed,B.LoginID,B.FName+' '+B.LName as EmpName,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,'D') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,'D') as ModificationDate, 
	Isnull(U1.FName,'') as CreatedByName,Isnull(U2.FName,'') as ModifiedByName,dbo.fnMinutesToTime(A.AMinutes) as TimeStr
	From tblAppointmentAvailability A
	Inner Join tblUser B on A.FKEmpID=B.PKUserID
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Where A.FKCompanyID=@FKCompanyID And A.BStatus=1
	And (A.PKID=@PKID Or @PKID=0)
	And (@DateWise=0 OR (A.OnDate Between @FromDate And @ToDate))
	And (@FKEmpID=0 Or A.FKEmpID=@FKEmpID)
	And (@RecType='' Or (@RecType='Available' And A.IsUsed=0) Or (@RecType='Booked' And A.IsUsed=1))
	Order By A.OnDate,A.FromTime

	
End
