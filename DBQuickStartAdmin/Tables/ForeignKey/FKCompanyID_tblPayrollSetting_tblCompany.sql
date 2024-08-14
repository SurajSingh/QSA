ALTER TABLE [dbo].[tblPayrollSetting]
	ADD CONSTRAINT [FKCompanyID_tblPayrollSetting_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
