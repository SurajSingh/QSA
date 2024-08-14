ALTER TABLE [dbo].[tblExpensesLog]
	ADD CONSTRAINT [FKCompanyID_tblExpensesLog_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
