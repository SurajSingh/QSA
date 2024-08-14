ALTER TABLE [dbo].[tblTaskAssignment]
	ADD CONSTRAINT [FKCreatedBy_tblTaskAssignment_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
