ALTER TABLE [dbo].[tblTimeSheet]
	ADD CONSTRAINT [FKCompanyID_tblTimeSheet_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
