ALTER TABLE [dbo].[tblPartyMaster]
	ADD CONSTRAINT [FKStateID_tblPartyMaster_tblStateMaster]
	FOREIGN KEY (FKStateID)
	REFERENCES [tblStateMaster] (PKStateID)
