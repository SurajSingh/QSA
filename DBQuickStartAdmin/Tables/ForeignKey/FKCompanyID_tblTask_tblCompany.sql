ALTER TABLE [dbo].[tblTask]
	ADD CONSTRAINT [FKCompanyID_tblTask_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
