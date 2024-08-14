ALTER TABLE [dbo].[tblUser]
	ADD CONSTRAINT [FKDeptID_tblUser_tblDeptMaster]
	FOREIGN KEY (FKDeptID)
	REFERENCES [tblDeptMaster] (PKDeptID)
