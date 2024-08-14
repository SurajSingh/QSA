ALTER TABLE [dbo].[tblClientSchedule]
	ADD CONSTRAINT [FKProjectID_tblClientSchedule_tblProject]
	FOREIGN KEY (FKProjectID)
	REFERENCES [tblProject] (PKID)
