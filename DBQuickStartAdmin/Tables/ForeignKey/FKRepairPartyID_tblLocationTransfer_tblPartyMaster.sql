ALTER TABLE [dbo].[tblLocationTransfer]
	ADD CONSTRAINT [FKRepairPartyID_tblLocationTransfer_tblPartyMaster]
	FOREIGN KEY (FKRepairPartyID)
	REFERENCES [tblPartyMaster] (PKID)
