ALTER TABLE [dbo].[tblPayrollSettingLeave]
	ADD CONSTRAINT [FKSettingID_tblPayrollSettingLeave_tblPayrollSetting]
	FOREIGN KEY (FKSettingID)
	REFERENCES [tblPayrollSetting] (PKID)
