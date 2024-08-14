ALTER TABLE [dbo].[tblAsset]
	ADD CONSTRAINT [FKPartyID_tblAsset_tblPartyMaster]
	FOREIGN KEY (FKPartyID)
	REFERENCES [tblPartyMaster] (PKID)
