ALTER TABLE [dbo].[tblPartyMaster]
	ADD CONSTRAINT [FKCountryID_tblPartyMaster_tblCountryMaster]
	FOREIGN KEY (FKCountryID)
	REFERENCES [tblCountryMaster] (PKCountryID)
