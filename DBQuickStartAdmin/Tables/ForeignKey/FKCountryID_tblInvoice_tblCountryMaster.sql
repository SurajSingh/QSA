ALTER TABLE [dbo].[tblInvoice]
	ADD CONSTRAINT [FKCountryID_tblInvoice_tblCountryMaster]
	FOREIGN KEY (FKCountryID)
	REFERENCES [tblCountryMaster] (PKCountryID)
