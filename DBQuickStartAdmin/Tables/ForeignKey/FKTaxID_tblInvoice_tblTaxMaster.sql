ALTER TABLE [dbo].[tblInvoice]
	ADD CONSTRAINT [FKTaxID_tblInvoice_tblTaxMaster]
	FOREIGN KEY (FKTaxID)
	REFERENCES [tblTaxMaster] (PKID)
