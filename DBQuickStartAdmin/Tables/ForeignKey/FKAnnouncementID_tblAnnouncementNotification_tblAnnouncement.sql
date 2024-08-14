ALTER TABLE [dbo].[tblAnnouncementNotification]
	ADD CONSTRAINT [FKAnnouncementID_tblAnnouncementNotification_tblAnnouncement]
	FOREIGN KEY (FKAnnouncementID)
	REFERENCES [tblAnnouncement] (PKID)
