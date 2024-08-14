ALTER TABLE [dbo].[tblClientSchedule]
	ADD CONSTRAINT [FKWorkTypeID_tblClientSchedule_tblWorkTypeMaster]
	FOREIGN KEY (FKWorkTypeID)
	REFERENCES [tblWorkTypeMaster] (PKID)
