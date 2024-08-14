ALTER TABLE [dbo].[tblTimeSheet]
	ADD CONSTRAINT [FKTaskID_tblTimeSheet_tblTask]
	FOREIGN KEY (FKTaskID)
	REFERENCES [tblTask] (PKID)
