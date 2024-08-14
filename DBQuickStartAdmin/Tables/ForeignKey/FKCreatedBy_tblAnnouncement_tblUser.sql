ALTER TABLE [dbo].[tblAnnouncement]
	ADD CONSTRAINT [FKCreatedBy_tblAnnouncement_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
