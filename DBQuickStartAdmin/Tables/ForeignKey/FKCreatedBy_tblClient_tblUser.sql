ALTER TABLE [dbo].[tblClient]
	ADD CONSTRAINT [FKCreatedBy_tblClient_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
