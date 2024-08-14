ALTER TABLE [dbo].[tblUser]
	ADD CONSTRAINT [FKStateID_tblUser_tblStateMaster]
	FOREIGN KEY (FKStateID)
	REFERENCES [tblStateMaster] (PKStateID)
