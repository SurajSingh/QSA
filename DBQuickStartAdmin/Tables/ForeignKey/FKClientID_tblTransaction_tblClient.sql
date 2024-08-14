ALTER TABLE [dbo].[tblTransaction]
	ADD CONSTRAINT [FKClientID_tblTransaction_tblClient]
	FOREIGN KEY (FKClientID)
	REFERENCES [tblClient] (PKID)
