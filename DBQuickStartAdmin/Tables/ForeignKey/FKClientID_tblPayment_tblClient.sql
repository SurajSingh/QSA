ALTER TABLE [dbo].[tblPayment]
	ADD CONSTRAINT [FKClientID_tblPayment_tblClient]
	FOREIGN KEY (FKClientID)
	REFERENCES [tblClient] (PKID)
