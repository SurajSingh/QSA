ALTER TABLE [dbo].[tblTransaction]
	ADD CONSTRAINT [FKLastModifiedBy_tblTransaction_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
