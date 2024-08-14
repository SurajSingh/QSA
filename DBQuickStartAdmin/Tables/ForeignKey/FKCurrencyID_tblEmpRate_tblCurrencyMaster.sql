ALTER TABLE [dbo].[tblEmpRate]
	ADD CONSTRAINT [FKCurrencyID_tblEmpRate_tblCurrencyMaster]
	FOREIGN KEY (FKCurrencyID)
	REFERENCES [tblCurrencyMaster] (PKCurrencyID)
