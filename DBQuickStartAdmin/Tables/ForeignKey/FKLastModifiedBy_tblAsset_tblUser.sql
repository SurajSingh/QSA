ALTER TABLE [dbo].[tblAsset]
	ADD CONSTRAINT [FKLastModifiedBy_tblAsset_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
