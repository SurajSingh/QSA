ALTER TABLE [dbo].[tblInvoice]
	ADD CONSTRAINT [FKCurrencyID_tblInvoice_tblCurrencyMaster]
	FOREIGN KEY (FKCurrencyID)
	REFERENCES [tblCurrencyMaster] (PKCurrencyID)
