ALTER TABLE [dbo].[tblExpenseGroupDetail]
	ADD CONSTRAINT [FKExpID_tblExpenseGroupDetail_tblTask]
	FOREIGN KEY (FKExpID)
	REFERENCES [tblTask] (PKID)
