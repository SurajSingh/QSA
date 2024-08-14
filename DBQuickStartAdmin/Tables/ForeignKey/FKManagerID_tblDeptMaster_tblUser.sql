ALTER TABLE [dbo].[tblDeptMaster]
	ADD CONSTRAINT [FKManagerID_tblDeptMaster_tblUser]
	FOREIGN KEY (FKManagerID)
	REFERENCES [tblUser] (PKUserID)
