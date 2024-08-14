ALTER TABLE [dbo].[tblAsset]
	ADD CONSTRAINT [FKConditionID_tblAsset_tblAssetConditionMaster]
	FOREIGN KEY (FKConditionID)
	REFERENCES [tblAssetConditionMaster] (PKID)
