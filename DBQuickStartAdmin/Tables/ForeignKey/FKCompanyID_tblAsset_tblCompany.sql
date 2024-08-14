ALTER TABLE [dbo].[tblAsset]
	ADD CONSTRAINT [FKCompanyID_tblAsset_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
