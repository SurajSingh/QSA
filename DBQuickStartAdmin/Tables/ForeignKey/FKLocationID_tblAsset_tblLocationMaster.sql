ALTER TABLE [dbo].[tblAsset]
	ADD CONSTRAINT [FKLocationID_tblAsset_tblLocationMaster]
	FOREIGN KEY (FKLocationID)
	REFERENCES [tblLocationMaster] (PKID)
