ALTER TABLE [dbo].[tblTask]
	ADD CONSTRAINT [FKLastModifiedBy_tblTask_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
