ALTER TABLE [dbo].[tblTransaction]
	ADD CONSTRAINT [FKInvoiceID_tblTransaction_tblInvoice]
	FOREIGN KEY (FKInvoiceID)
	REFERENCES [tblInvoice] (PKID)
