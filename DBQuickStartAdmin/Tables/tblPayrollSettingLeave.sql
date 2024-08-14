CREATE TABLE [dbo].[tblPayrollSettingLeave]
(
	PKID			Bigint Not Null,
	FKSettingID		Bigint,
	LeaveName		Varchar(50),
	PayType			Varchar(50),
	PerMonthAccr	Decimal(18,2),
	LeaveCount		Decimal(18,2),
	CFNextYear		Bit
)
