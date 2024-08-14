ALTER TABLE [dbo].[tblLocationTransfer]
	ADD CONSTRAINT [FKAssetID_tblLocationTransfer_tblAsset]
	FOREIGN KEY (FKAssetID)
	REFERENCES [tblAsset] (PKID)
