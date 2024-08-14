ALTER TABLE [dbo].[tblItemLot]
	ADD CONSTRAINT [FKCompanyID_tblItemLot_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
