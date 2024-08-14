ALTER TABLE [dbo].[tblExpenseGroup]
	ADD CONSTRAINT [FKCompanyID_tblExpenseGroup_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
