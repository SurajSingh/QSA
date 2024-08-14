ALTER TABLE [dbo].[tblHoliday]
	ADD CONSTRAINT [FKCompanyID_tblHoliday_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
