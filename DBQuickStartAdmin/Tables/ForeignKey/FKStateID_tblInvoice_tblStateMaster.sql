ALTER TABLE [dbo].[tblInvoice]
	ADD CONSTRAINT [FKStateID_tblInvoice_tblStateMaster]
	FOREIGN KEY (FKStateID)
	REFERENCES [tblStateMaster] (PKStateID)
