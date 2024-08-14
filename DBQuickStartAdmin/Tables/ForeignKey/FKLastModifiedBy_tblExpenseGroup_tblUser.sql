ALTER TABLE [dbo].[tblExpenseGroup]
	ADD CONSTRAINT [FKLastModifiedBy_tblExpenseGroup_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
