ALTER TABLE [dbo].[tblTimeSheet]
	ADD CONSTRAINT [FKSubmitToID_tblTimeSheet_tblUser]
	FOREIGN KEY (FKSubmitToID)
	REFERENCES [tblUser] (PKUserID)
