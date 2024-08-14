ALTER TABLE [dbo].[tblClientGroup]
	ADD CONSTRAINT [FKCreatedBy_tblClientGroup_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
