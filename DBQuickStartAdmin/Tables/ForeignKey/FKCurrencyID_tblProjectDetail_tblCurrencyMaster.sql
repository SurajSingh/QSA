ALTER TABLE [dbo].[tblProjectDetail]
	ADD CONSTRAINT [FKCurrencyID_tblProjectDetail_tblCurrencyMaster]
	FOREIGN KEY (FKCurrencyID)
	REFERENCES [tblCurrencyMaster] (PKCurrencyID)
