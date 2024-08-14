ALTER TABLE [dbo].[tblExpensesLog]
	ADD CONSTRAINT [FKTaskID_tblExpensesLog_tblTask]
	FOREIGN KEY (FKTaskID)
	REFERENCES [tblTask] (PKID)
