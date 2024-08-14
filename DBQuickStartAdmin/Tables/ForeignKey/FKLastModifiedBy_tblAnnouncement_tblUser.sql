ALTER TABLE [dbo].[tblAnnouncement]
	ADD CONSTRAINT [FKLastModifiedBy_tblAnnouncement_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
