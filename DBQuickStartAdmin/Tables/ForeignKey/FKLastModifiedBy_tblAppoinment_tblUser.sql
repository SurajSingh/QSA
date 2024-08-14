ALTER TABLE [dbo].[tblAppoinment]
	ADD CONSTRAINT [FKLastModifiedBy_tblAppoinment_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
