ALTER TABLE [dbo].[tblBudgetDetail]
	ADD CONSTRAINT [FKTaskID_tblBudgetDetail_tblTask]
	FOREIGN KEY (FKTaskID)
	REFERENCES [tblTask] (PKID)
