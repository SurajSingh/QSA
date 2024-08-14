ALTER TABLE [dbo].[tblTimeSheet]
	ADD CONSTRAINT [FKAssignLogID_tblTimeSheet_tblTaskAssignment]
	FOREIGN KEY (FKAssignLogID)
	REFERENCES [tblTaskAssignment] (PKID)
