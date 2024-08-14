ALTER TABLE [dbo].[tblProjectBudget]
	ADD CONSTRAINT [FKCreatedBy_tblProjectBudget_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
