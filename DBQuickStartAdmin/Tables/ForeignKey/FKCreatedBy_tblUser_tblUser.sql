ALTER TABLE [dbo].[tblUser]
	ADD CONSTRAINT [FKCreatedBy_tblUser_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
