ALTER TABLE [dbo].[tblProjectModule]
	ADD CONSTRAINT [FKProjectID_tblProjectModule_tblProject]
	FOREIGN KEY (FKProjectID)
	REFERENCES [tblProject] (PKID)
