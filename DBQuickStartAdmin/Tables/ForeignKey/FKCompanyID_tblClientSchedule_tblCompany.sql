ALTER TABLE [dbo].[tblClientSchedule]
	ADD CONSTRAINT [FKCompanyID_tblClientSchedule_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
