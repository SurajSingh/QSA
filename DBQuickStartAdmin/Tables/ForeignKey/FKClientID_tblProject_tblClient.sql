ALTER TABLE [dbo].[tblProject]
	ADD CONSTRAINT [FKClientID_tblProject_tblClient]
	FOREIGN KEY (FKClientID)
	REFERENCES [tblClient] (PKID)
