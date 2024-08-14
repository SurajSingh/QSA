CREATE TABLE [dbo].[tblEmployeeLeaveBalance]
(
	PKID		Bigint Not Null,
	FKEmpID		Bigint, 
	FKYearID	Bigint,  
	FKLeaveID	Bigint, 
	OpBal		Decimal(18,2),
	AccrCount	Decimal(18,2),
	TakenCount	Decimal(18,2),
	ClosingBal	Decimal(18,2)
)
