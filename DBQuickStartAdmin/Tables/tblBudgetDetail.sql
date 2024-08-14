CREATE TABLE [dbo].[tblBudgetDetail]
(
	PKID				Bigint Not Null,
	FKBudgetID			Bigint,
	FKTaskID			Bigint,
	BudHrs				Decimal(18,2),
	CostRate			DECIMAL (18, 4) NULL,
    BillRate			DECIMAL (18, 4) NULL,
	IsBillable			BIT             NULL,
			
)
