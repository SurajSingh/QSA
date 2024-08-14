ALTER TABLE [dbo].[tblInvoice]
	ADD CONSTRAINT [FKCompanyID_tblInvoice_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
