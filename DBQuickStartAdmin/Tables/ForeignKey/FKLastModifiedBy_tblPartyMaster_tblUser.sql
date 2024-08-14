ALTER TABLE [dbo].[tblPartyMaster]
	ADD CONSTRAINT [FKLastModifiedBy_tblPartyMaster_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
