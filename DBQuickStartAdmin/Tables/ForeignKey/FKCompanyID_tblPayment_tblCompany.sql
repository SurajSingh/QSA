ALTER TABLE [dbo].[tblPayment]
	ADD CONSTRAINT [FKCompanyID_tblPayment_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
