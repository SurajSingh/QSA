ALTER TABLE [dbo].[tblTaskAssignment]
	ADD CONSTRAINT [FKProjectID_tblTaskAssignment_tblProject]
	FOREIGN KEY (FKProjectID)
	REFERENCES [tblProject] (PKID)
