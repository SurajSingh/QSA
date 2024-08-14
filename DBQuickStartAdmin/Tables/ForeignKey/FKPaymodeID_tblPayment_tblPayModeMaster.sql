ALTER TABLE [dbo].[tblPayment]
	ADD CONSTRAINT [FKPaymodeID_tblPayment_tblPayModeMaster]
	FOREIGN KEY (FKPaymodeID)
	REFERENCES [tblPayModeMaster] (PKID)
