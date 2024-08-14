ALTER TABLE [dbo].[tblDesigMaster]
	ADD CONSTRAINT [FKCompanyID_tblDesigMaster_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
