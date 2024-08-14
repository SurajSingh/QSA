ALTER TABLE [dbo].[tblLocationTransfer]
	ADD CONSTRAINT [FKCompanyID_tblLocationTransfer_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
