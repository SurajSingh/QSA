ALTER TABLE [dbo].[tblExpensesLog]
	ADD CONSTRAINT [FKEmpID_tblExpensesLog_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
