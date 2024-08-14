ALTER TABLE [dbo].[tblLocationTransfer]
	ADD CONSTRAINT [FKCreatedBy_tblLocationTransfer_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
