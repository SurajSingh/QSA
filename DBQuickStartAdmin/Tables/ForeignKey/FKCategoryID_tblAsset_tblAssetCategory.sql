ALTER TABLE [dbo].[tblAsset]
	ADD CONSTRAINT [FKCategoryID_tblAsset_tblAssetCategory]
	FOREIGN KEY (FKCategoryID)
	REFERENCES [tblAssetCategory] (PKID)
