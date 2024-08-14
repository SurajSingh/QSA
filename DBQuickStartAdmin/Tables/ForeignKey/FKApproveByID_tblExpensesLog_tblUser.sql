ALTER TABLE [dbo].[tblExpensesLog]
	ADD CONSTRAINT [FKApproveByID_tblExpensesLog_tblUser]
	FOREIGN KEY (FKApproveByID)
	REFERENCES [tblUser] (PKUserID)
