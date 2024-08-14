ALTER TABLE [dbo].[tblProjectDetail]
	ADD CONSTRAINT [FKTermID_tblProjectDetail_tblPaymentTerm]
	FOREIGN KEY (FKTermID)
	REFERENCES [tblPaymentTerm] (PKID)
