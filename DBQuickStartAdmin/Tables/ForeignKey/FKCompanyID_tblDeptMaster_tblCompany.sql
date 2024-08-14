ALTER TABLE [dbo].[tblDeptMaster]
	ADD CONSTRAINT [FKCompanyID_tblDeptMaster_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)