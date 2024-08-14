ALTER TABLE [dbo].[tblAppoinment]
	ADD CONSTRAINT [FKEmpID_tblAppoinment_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
