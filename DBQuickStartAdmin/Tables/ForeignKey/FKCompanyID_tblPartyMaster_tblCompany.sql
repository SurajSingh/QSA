ALTER TABLE [dbo].[tblPartyMaster]
	ADD CONSTRAINT [FKCompanyID_tblPartyMaster_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
