ALTER TABLE [dbo].[tblProjectBudget]
	ADD CONSTRAINT [FKProjectID_tblProjectBudget_tblProject]
	FOREIGN KEY (FKProjectID)
	REFERENCES [tblProject] (PKID)
