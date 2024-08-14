ALTER TABLE [dbo].[tblAssetCategory]
	ADD CONSTRAINT [FKLastModifiedBy_tblAssetCategory_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
