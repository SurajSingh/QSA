ALTER TABLE [dbo].[tblTaxMaster]
	ADD CONSTRAINT [FKCreatedBy_tblTaxMaster_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
