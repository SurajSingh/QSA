ALTER TABLE [dbo].[tblProjectModule]
	ADD CONSTRAINT [FKParentID_tblProjectModule_tblProjectModule]
	FOREIGN KEY (FKParentID)
	REFERENCES [tblProjectModule] (PKID)
