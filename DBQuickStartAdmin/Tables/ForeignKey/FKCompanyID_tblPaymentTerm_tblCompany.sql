ALTER TABLE [dbo].[tblPaymentTerm]
	ADD CONSTRAINT [FKCompanyID_tblPaymentTerm_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
