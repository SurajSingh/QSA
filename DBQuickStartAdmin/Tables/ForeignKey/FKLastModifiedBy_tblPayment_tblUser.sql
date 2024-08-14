ALTER TABLE [dbo].[tblPayment]
	ADD CONSTRAINT [FKLastModifiedBy_tblPayment_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
