ALTER TABLE [dbo].[tblTableLayout]
	ADD CONSTRAINT [FKUserID_tblTableLayout_tblUser]
	FOREIGN KEY (FKUserID)
	REFERENCES [tblUser] (PKUserID)
