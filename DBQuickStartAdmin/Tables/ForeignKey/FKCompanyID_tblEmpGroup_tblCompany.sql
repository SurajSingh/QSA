ALTER TABLE [dbo].[tblEmpGroup]
	ADD CONSTRAINT [FKCompanyID_tblEmpGroup_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
