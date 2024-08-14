ALTER TABLE [dbo].[tblProjectBudget]
	ADD CONSTRAINT [FKCompanyID_tblProjectBudget_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
