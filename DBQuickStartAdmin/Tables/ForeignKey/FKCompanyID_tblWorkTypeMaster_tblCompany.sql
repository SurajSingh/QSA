ALTER TABLE [dbo].[tblWorkTypeMaster]
	ADD CONSTRAINT [FKCompanyID_tblWorkTypeMaster_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
