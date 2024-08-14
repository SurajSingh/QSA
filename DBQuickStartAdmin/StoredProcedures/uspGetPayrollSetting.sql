CREATE PROCEDURE [dbo].[uspGetPayrollSetting]
	@PKID			 Bigint,
	@FKCompanyID     Bigint

AS
Begin
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	Select @PKID=PKID FRom tblPayrollSetting where FKCompanyID=@FKCompanyID

	Select PKID, StartMonth, EndMonth, LeaveRule From tblPayrollSetting where PKID=@PKID
	Select  PKID,FKSettingID, LeaveName,LeaveCount,PayType,PerMonthAccr From tblPayrollSettingLeave Where FKSettingID=@PKID
	Select  A.PKID,FKSettingID,A.DayNum,IsOn,dbo.fnGetDateFormat(StartTime,@DateForStr,'T') as StartTime,dbo.fnGetDateFormat(EndTime,@DateForStr,'T') as EndTime,B.ShortName,B.WDayName  From tblPayrollSettingWorkingDays A Left Join tblWeekDays B on A.DayNum=B.PKID Where A.FKSettingID=@PKID


End
