ALTER TABLE [dbo].[tblClient]
	ADD CONSTRAINT [FKCountryID_tblClient_tblCountryMaster]
	FOREIGN KEY (FKCountryID)
	REFERENCES [tblCountryMaster] (PKCountryID)
