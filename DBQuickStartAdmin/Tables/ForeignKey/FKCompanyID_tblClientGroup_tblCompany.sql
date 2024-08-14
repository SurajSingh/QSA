ALTER TABLE [dbo].[tblClientGroup]
	ADD CONSTRAINT [FKCompanyID_tblClientGroup_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
