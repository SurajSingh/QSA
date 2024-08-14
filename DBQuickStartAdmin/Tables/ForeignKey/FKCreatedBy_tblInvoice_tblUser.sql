ALTER TABLE [dbo].[tblInvoice]
	ADD CONSTRAINT [FKCreatedBy_tblInvoice_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
