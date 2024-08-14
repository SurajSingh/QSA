ALTER TABLE [dbo].[tblTaskAssignment]
	ADD CONSTRAINT [FKCompanyID_tblTaskAssignment_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
