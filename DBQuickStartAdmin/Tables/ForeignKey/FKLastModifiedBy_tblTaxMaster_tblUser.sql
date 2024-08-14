ALTER TABLE [dbo].[tblTaxMaster]
	ADD CONSTRAINT [FKLastModifiedBy_tblTaxMaster_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
