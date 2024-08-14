ALTER TABLE [dbo].[tblClientScheduleDetail]
	ADD CONSTRAINT [FKID_tblClientScheduleDetail_tblClientSchedule]
	FOREIGN KEY (FKID)
	REFERENCES [tblClientSchedule] (PKID)
