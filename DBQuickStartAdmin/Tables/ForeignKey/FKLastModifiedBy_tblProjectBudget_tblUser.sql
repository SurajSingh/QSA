ALTER TABLE [dbo].[tblProjectBudget]
	ADD CONSTRAINT [FKLastModifiedBy_tblProjectBudget_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
