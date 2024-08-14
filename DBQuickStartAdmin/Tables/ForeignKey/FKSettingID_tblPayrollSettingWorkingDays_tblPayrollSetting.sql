ALTER TABLE [dbo].[tblPayrollSettingWorkingDays]
	ADD CONSTRAINT [FKSettingID_tblPayrollSettingWorkingDays_tblPayrollSetting]
	FOREIGN KEY (FKSettingID)
	REFERENCES [tblPayrollSetting] (PKID)
