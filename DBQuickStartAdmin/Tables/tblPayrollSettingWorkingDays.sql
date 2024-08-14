CREATE TABLE [dbo].[tblPayrollSettingWorkingDays]
(
	PKID		Bigint Not Null,
	FKSettingID	Bigint,
	DayNum		Bigint,
	IsOn		Bit,
	StartTime	Time,
	EndTime		Time
)
