ALTER TABLE [dbo].[tblPayment]
	ADD CONSTRAINT [FKPaymentTypeID_tblPayment_tblPaymentType]
	FOREIGN KEY (FKPaymentTypeID)
	REFERENCES [tblPaymentType] (PKID)
