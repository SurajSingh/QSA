ALTER TABLE [dbo].[tblTimeSheet]
	ADD CONSTRAINT [FKEmpID_tblTimeSheet_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
