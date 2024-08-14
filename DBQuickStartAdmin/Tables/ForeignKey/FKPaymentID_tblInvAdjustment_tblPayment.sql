ALTER TABLE [dbo].[tblInvAdjustment]
	ADD CONSTRAINT [FKPaymentID_tblInvAdjustment_tblPayment]
	FOREIGN KEY (FKPaymentID)
	REFERENCES [tblPayment] (PKID)
