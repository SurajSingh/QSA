ALTER TABLE [dbo].[tblExpensesLog]
	ADD CONSTRAINT [FKCreatedBy_tblExpensesLog_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
