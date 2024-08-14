ALTER TABLE [dbo].[tblInvoice]
	ADD CONSTRAINT [FKProjectID_tblInvoice_tblProject]
	FOREIGN KEY (FKProjectID)
	REFERENCES [tblProject] (PKID)
