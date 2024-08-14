ALTER TABLE [dbo].[tblClientSchedule]
	ADD CONSTRAINT [FKCreatedBy_tblClientSchedule_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
