ALTER TABLE [dbo].[tblTransaction]
	ADD CONSTRAINT [FKCompanyID_tblTransaction_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
