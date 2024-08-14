ALTER TABLE [dbo].[tblAsset]
	ADD CONSTRAINT [FKCreatedBy_tblAsset_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
