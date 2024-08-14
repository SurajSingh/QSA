ALTER TABLE [dbo].[tblProject]
	ADD CONSTRAINT [FKCompanyID_tblProject_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
