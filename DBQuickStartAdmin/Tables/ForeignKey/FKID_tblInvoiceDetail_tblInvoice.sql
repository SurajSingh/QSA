ALTER TABLE [dbo].[tblInvoiceDetail]
	ADD CONSTRAINT [FKID_tblInvoiceDetail_tblInvoice]
	FOREIGN KEY (FKID)
	REFERENCES [tblInvoice] (PKID)
