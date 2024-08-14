ALTER TABLE [dbo].[tblPartyMaster]
	ADD CONSTRAINT [FKCreatedBy_tblPartyMaster_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
