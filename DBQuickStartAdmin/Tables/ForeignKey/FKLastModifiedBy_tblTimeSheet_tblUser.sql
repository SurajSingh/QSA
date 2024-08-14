ALTER TABLE [dbo].[tblTimeSheet]
	ADD CONSTRAINT [FKLastModifiedBy_tblTimeSheet_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
