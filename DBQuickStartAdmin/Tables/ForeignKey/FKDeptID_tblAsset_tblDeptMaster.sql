ALTER TABLE [dbo].[tblAsset]
	ADD CONSTRAINT [FKDeptID_tblAsset_tblDeptMaster]
	FOREIGN KEY (FKDeptID)
	REFERENCES [tblDeptMaster] (PKDeptID)
