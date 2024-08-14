ALTER TABLE [dbo].[tblClientGroup]
	ADD CONSTRAINT [FKLastModifiedBy_tblClientGroup_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
