ALTER TABLE [dbo].[tblLocationTransfer]
	ADD CONSTRAINT [FKDeptID_tblLocationTransfer_tblDeptMaster]
	FOREIGN KEY (FKDeptID)
	REFERENCES [tblDeptMaster] (PKDeptID)
