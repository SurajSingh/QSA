ALTER TABLE [dbo].[tblClientSchedule]
	ADD CONSTRAINT [FKStatusID_tblClientSchedule_tblScheduleStatus]
	FOREIGN KEY (FKStatusID)
	REFERENCES [tblScheduleStatus] (PKID)
