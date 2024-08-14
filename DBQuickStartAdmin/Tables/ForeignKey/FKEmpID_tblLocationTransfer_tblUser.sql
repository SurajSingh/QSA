ALTER TABLE [dbo].[tblLocationTransfer]
	ADD CONSTRAINT [FKEmpID_tblLocationTransfer_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
