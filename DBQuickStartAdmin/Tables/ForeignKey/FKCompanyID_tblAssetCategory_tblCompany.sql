ALTER TABLE [dbo].[tblAssetCategory]
	ADD CONSTRAINT [FKCompanyID_tblAssetCategory_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
