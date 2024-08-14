ALTER TABLE [dbo].[tblClient]
	ADD CONSTRAINT [FKCompanyID_tblClient_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
