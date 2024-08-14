ALTER TABLE [dbo].[tblEmployeeLeaveBalance]
	ADD CONSTRAINT [FKEmpID_tblEmployeeLeaveBalance_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
