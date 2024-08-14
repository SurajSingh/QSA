ALTER TABLE [dbo].[tblLocationTransfer]
	ADD CONSTRAINT [FKLocationID_tblLocationTransfer_tblLocationMaster]
	FOREIGN KEY (FKLocationID)
	REFERENCES [tblLocationMaster] (PKID)
