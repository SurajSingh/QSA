ALTER TABLE [dbo].[tblImportLog]
	ADD CONSTRAINT [FKCompanyID_tblImportLog_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
