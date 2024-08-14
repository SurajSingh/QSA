ALTER TABLE [dbo].[tblTaxMaster]
	ADD CONSTRAINT [FKCompanyID_tblTaxMaster_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
