ALTER TABLE [dbo].[tblPaymentTerm]
	ADD CONSTRAINT [FKLastModifiedBy_tblPaymentTerm_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
