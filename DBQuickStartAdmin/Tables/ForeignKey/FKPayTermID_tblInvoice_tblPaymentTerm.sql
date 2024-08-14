ALTER TABLE [dbo].[tblInvoice]
	ADD CONSTRAINT [FKPayTermID_tblInvoice_tblPaymentTerm]
	FOREIGN KEY (FKPayTermID)
	REFERENCES [tblPaymentTerm] (PKID)
