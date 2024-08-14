ALTER TABLE [dbo].[tblInvAdjustment]
	ADD CONSTRAINT [FKInvoiceID_tblInvAdjustment_tblInvoice]
	FOREIGN KEY (FKInvoiceID)
	REFERENCES [tblInvoice] (PKID)
