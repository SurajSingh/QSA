ALTER TABLE [dbo].[tblClient]
	ADD CONSTRAINT [FKStateID_tblClient_tblStateMaster]
	FOREIGN KEY (FKStateID)
	REFERENCES [tblStateMaster] (PKStateID)
