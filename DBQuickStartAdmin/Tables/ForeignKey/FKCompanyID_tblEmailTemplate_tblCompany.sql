ALTER TABLE [dbo].[tblEmailTemplate]
	ADD CONSTRAINT [FKCompanyID_tblEmailTemplate_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
