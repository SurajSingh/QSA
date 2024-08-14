ALTER TABLE [dbo].[tblClient]
	ADD CONSTRAINT [FKManagerID_tblClient_tblUser]
	FOREIGN KEY (FKManagerID)
	REFERENCES [tblUser] (PKUserID)
