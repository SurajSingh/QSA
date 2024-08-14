ALTER TABLE [dbo].[tblAnnouncementNotification]
	ADD CONSTRAINT [FKUserID_tblAnnouncementNotification_tblUser]
	FOREIGN KEY (FKUserID)
	REFERENCES [tblUser] (PKUserID)
