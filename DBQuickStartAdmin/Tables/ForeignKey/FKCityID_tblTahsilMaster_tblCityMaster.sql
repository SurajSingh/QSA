ALTER TABLE [dbo].[tblTahsilMaster]
	ADD CONSTRAINT [FKCityID_tblTahsilMaster_tblCityMaster]
	FOREIGN KEY (FKCityID)
	REFERENCES [tblCityMaster] (PKCityID)
