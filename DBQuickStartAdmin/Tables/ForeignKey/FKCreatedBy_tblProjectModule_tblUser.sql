ALTER TABLE [dbo].[tblProjectModule]
	ADD CONSTRAINT [FKCreatedBy_tblProjectModule_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
