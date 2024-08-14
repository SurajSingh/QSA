ALTER TABLE [dbo].[tblLeaveRequest]
	ADD CONSTRAINT [FKLeaveID_tblLeaveRequest_tblPayrollSettingLeave]
	FOREIGN KEY (FKLeaveID)
	REFERENCES [tblPayrollSettingLeave] (PKID)
