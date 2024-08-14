ALTER TABLE [dbo].[tblAppoinment]
	ADD CONSTRAINT [FKCompanyID_tblAppoinment_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
