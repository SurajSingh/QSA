ALTER TABLE [dbo].[tblClient]
	ADD CONSTRAINT [FKCityID_tblClient_tblCityMaster]
	FOREIGN KEY (FKCityID)
	REFERENCES [tblCityMaster] (PKCityID)
