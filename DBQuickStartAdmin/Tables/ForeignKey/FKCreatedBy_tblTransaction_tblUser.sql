ALTER TABLE [dbo].[tblTransaction]
	ADD CONSTRAINT [FKCreatedBy_tblTransaction_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
