ALTER TABLE [dbo].[tblProjectDetail]
	ADD CONSTRAINT [FKTaxID_tblProjectDetail_tblTaxMaster]
	FOREIGN KEY (FKTaxID)
	REFERENCES [tblTaxMaster] (PKID)
