ALTER TABLE [dbo].[tblUser]
	ADD CONSTRAINT [FKTimezoneID_tblUser_tblTimeZoneMaster]
	FOREIGN KEY (FKTimezoneID)
	REFERENCES [tblTimeZoneMaster] (PKTimeZoneID)
