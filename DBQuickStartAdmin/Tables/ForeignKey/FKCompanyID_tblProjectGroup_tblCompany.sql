ALTER TABLE [dbo].[tblProjectGroup]
	ADD CONSTRAINT [FKCompanyID_tblProjectGroup_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
