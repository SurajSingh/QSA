ALTER TABLE [dbo].[tblProjectDetail]
	ADD CONSTRAINT [FKBillingFrequency_tblProjectDetail_tblBillingFrequency]
	FOREIGN KEY (FKBillingFrequency)
	REFERENCES [tblBillingFrequency] (PKID)
