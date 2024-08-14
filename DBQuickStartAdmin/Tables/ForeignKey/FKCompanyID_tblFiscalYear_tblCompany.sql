ALTER TABLE [dbo].[tblFiscalYear]
	ADD CONSTRAINT [FKCompanyID_tblFiscalYear_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
