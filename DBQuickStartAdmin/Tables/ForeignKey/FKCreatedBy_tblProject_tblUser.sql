ALTER TABLE [dbo].[tblProject]
	ADD CONSTRAINT [FKCreatedBy_tblProject_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
