CREATE PROCEDURE [dbo].[uspGetHoliday]
		@PKID	Bigint,
		@FKCompanyID	Bigint 
AS
Begin
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	Select 1 as Result,PKID,dbo.fnGetDateFormat(HolidayDate,@DateForStr,'D') as HolidayDate,HolidayName,HolidayDesc
	From tblHoliday 
	Where (PKID=@PKID Or @PKID=0)
	And FKCompanyID=@FKCompanyID
	Order by HolidayDate
End