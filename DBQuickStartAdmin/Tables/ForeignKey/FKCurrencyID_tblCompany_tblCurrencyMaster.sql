ALTER TABLE [dbo].[tblCompany]
	ADD CONSTRAINT [FKCurrencyID_tblCompany_tblCurrencyMaster]
	FOREIGN KEY (FKCurrencyID)
	REFERENCES [tblCurrencyMaster] (PKCurrencyID)
