ALTER TABLE [dbo].[tblAsset]
	ADD CONSTRAINT [FKRepairPartyID_tblAsset_tblPartyMaster]
	FOREIGN KEY (FKRepairPartyID)
	REFERENCES [tblPartyMaster] (PKID)
