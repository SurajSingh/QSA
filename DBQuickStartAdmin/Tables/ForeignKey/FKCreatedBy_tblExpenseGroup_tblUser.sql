ALTER TABLE [dbo].[tblExpenseGroup]
	ADD CONSTRAINT [FKCreatedBy_tblExpenseGroup_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
