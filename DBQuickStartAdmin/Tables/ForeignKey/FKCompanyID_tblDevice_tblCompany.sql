ALTER TABLE [dbo].[tblDevice]
	ADD CONSTRAINT [FKCompanyID_tblDevice_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
