ALTER TABLE [dbo].[tblImportUserDef]
	ADD CONSTRAINT [FKCompanyID_tblImportUserDef_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
