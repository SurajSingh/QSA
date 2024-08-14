ALTER TABLE [dbo].[tblTaskAssignment]
	ADD CONSTRAINT [FKLastModifiedBy_tblTaskAssignment_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
