ALTER TABLE [dbo].[tblLocationTransfer]
	ADD CONSTRAINT [FKPrevID_tblLocationTransfer_tblLocationTransfer]
	FOREIGN KEY (FKPrevID)
	REFERENCES [tblLocationTransfer] (PKID)
