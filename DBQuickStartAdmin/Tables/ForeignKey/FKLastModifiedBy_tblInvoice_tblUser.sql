ALTER TABLE [dbo].[tblInvoice]
	ADD CONSTRAINT [FKLastModifiedBy_tblInvoice_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
