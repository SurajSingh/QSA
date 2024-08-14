ALTER TABLE [dbo].[tblPayment]
	ADD CONSTRAINT [FKCreatedBy_tblPayment_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
