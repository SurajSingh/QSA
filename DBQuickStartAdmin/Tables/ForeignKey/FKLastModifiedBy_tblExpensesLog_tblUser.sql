ALTER TABLE [dbo].[tblExpensesLog]
	ADD CONSTRAINT [FKLastModifiedBy_tblExpensesLog_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
