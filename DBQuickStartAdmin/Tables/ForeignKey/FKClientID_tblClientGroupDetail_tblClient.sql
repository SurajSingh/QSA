ALTER TABLE [dbo].[tblClientGroupDetail]
	ADD CONSTRAINT [FKClientID_tblClientGroupDetail_tblClient]
	FOREIGN KEY (FKClientID)
	REFERENCES [tblClient] (PKID)
