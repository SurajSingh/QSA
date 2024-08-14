ALTER TABLE [dbo].[tblTimeSheet]
	ADD CONSTRAINT [FKApproveByID_tblTimeSheet_tblUser]
	FOREIGN KEY (FKApproveByID)
	REFERENCES [tblUser] (PKUserID)
