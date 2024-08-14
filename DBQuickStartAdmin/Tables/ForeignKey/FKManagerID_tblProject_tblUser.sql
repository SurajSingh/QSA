ALTER TABLE [dbo].[tblProject]
	ADD CONSTRAINT [FKManagerID_tblProject_tblUser]
	FOREIGN KEY (FKManagerID)
	REFERENCES [tblUser] (PKUserID)
