ALTER TABLE [dbo].[tblBudgetDetail]
	ADD CONSTRAINT [FKBudgetID_tblBudgetDetail_tblProjectBudget]
	FOREIGN KEY (FKBudgetID)
	REFERENCES [tblProjectBudget] (PKID)
