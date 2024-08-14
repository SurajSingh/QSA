ALTER TABLE [dbo].[tblTableLayout]
	ADD CONSTRAINT [FKCompanyID_tblTableLayout_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
