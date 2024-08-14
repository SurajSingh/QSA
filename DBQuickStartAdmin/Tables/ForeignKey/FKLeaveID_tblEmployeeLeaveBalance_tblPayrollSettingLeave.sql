ALTER TABLE [dbo].[tblEmployeeLeaveBalance]
	ADD CONSTRAINT [FKLeaveID_tblEmployeeLeaveBalance_tblPayrollSettingLeave]
	FOREIGN KEY (FKLeaveID)
	REFERENCES [tblPayrollSettingLeave] (PKID)
