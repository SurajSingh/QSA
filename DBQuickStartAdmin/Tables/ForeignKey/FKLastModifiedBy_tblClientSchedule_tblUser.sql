ALTER TABLE [dbo].[tblClientSchedule]
	ADD CONSTRAINT [FKLastModifiedBy_tblClientSchedule_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
