ALTER TABLE [dbo].[tblCompany]
	ADD CONSTRAINT [FKTimezoneID_tblCompany_tblTimeZoneMaster]
	FOREIGN KEY (FKTimezoneID)
	REFERENCES [tblTimeZoneMaster] (PKTimeZoneID)
