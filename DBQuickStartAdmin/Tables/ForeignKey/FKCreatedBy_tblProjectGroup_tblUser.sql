ALTER TABLE [dbo].[tblProjectGroup]
	ADD CONSTRAINT [FKCreatedBy_tblProjectGroup_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
