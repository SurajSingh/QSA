ALTER TABLE [dbo].[tblExpenseGroupDetail]
	ADD CONSTRAINT [FKID_tblExpenseGroupDetail_tblExpenseGroup]
	FOREIGN KEY (FKID)
	REFERENCES [tblExpenseGroup] (PKID)
