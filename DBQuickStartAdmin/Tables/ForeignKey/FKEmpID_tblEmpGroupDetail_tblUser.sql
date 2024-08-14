ALTER TABLE [dbo].[tblEmpGroupDetail]
	ADD CONSTRAINT [FKEmpID_tblEmpGroupDetail_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
