ALTER TABLE [dbo].[tblTimeSheet]
	ADD CONSTRAINT [FKCreatedBy_tblTimeSheet_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
