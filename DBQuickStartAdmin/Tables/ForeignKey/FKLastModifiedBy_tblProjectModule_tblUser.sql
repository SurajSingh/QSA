ALTER TABLE [dbo].[tblProjectModule]
	ADD CONSTRAINT [FKLastModifiedBy_tblProjectModule_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
