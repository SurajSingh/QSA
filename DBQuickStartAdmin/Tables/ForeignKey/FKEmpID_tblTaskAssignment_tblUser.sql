ALTER TABLE [dbo].[tblTaskAssignment]
	ADD CONSTRAINT [FKEmpID_tblTaskAssignment_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
