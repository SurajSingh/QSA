ALTER TABLE [dbo].[tblInvoice]
	ADD CONSTRAINT [FKCityID_tblInvoice_tblCityMaster]
	FOREIGN KEY (FKCityID)
	REFERENCES [tblCityMaster] (PKCityID)
