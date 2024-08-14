ALTER TABLE [dbo].[tblAsset]
	ADD CONSTRAINT [FKEmpID_tblAsset_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
