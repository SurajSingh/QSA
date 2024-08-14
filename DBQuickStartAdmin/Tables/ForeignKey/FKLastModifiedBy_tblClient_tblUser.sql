ALTER TABLE [dbo].[tblClient]
	ADD CONSTRAINT [FKLastModifiedBy_tblClient_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
