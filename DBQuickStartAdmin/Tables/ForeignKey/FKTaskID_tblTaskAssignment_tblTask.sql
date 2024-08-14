ALTER TABLE [dbo].[tblTaskAssignment]
	ADD CONSTRAINT [FKTaskID_tblTaskAssignment_tblTask]
	FOREIGN KEY (FKTaskID)
	REFERENCES [tblTask] (PKID)
