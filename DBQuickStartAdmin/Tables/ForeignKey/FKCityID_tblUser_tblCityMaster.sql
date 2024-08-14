ALTER TABLE [dbo].[tblUser]
	ADD CONSTRAINT [FKCityID_tblUser_tblCityMaster]
	FOREIGN KEY (FKCityID)
	REFERENCES [tblCityMaster] (PKCityID)
