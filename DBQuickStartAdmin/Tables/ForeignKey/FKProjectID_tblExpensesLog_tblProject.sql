ALTER TABLE [dbo].[tblExpensesLog]
	ADD CONSTRAINT [FKProjectID_tblExpensesLog_tblProject]
	FOREIGN KEY (FKProjectID)
	REFERENCES [tblProject] (PKID)
