ALTER TABLE [dbo].[tblCityMaster]
	ADD CONSTRAINT [FKStateID_tblCityMaster_tblStateMaster]
	FOREIGN KEY (FKStateID)
	REFERENCES [tblStateMaster] (PKStateID)
