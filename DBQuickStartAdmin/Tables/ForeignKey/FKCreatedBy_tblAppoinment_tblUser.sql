ALTER TABLE [dbo].[tblAppoinment]
	ADD CONSTRAINT [FKCreatedBy_tblAppoinment_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
