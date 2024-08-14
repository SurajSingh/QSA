ALTER TABLE [dbo].[tblAssetCategory]
	ADD CONSTRAINT [FKCreatedBy_tblAssetCategory_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
