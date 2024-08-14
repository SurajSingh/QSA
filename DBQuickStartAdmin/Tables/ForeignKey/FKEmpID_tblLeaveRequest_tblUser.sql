ALTER TABLE [dbo].[tblLeaveRequest]
	ADD CONSTRAINT [FKEmpID_tblLeaveRequest_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
