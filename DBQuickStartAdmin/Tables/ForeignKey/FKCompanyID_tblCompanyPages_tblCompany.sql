ALTER TABLE [dbo].[tblCompanyPages]
	ADD CONSTRAINT [FKCompanyID_tblCompanyPages_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
