ALTER TABLE [dbo].[tblPartyMaster]
	ADD CONSTRAINT [FKCityID_tblPartyMaster_tblCityMaster]
	FOREIGN KEY (FKCityID)
	REFERENCES [tblCityMaster] (PKCityID)
