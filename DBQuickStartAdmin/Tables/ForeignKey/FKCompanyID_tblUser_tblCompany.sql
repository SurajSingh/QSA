ALTER TABLE [dbo].[tblUser]
	ADD CONSTRAINT [FKCompanyID_tblUser_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
