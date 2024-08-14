ALTER TABLE [dbo].[tblTask]
	ADD CONSTRAINT [FKCreatedBy_tblTask_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
