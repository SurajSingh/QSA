ALTER TABLE [dbo].[tblPaymentTerm]
	ADD CONSTRAINT [FKCreatedBy_tblPaymentTerm_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
