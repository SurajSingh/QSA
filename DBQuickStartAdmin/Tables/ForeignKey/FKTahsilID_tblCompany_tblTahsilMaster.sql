ALTER TABLE [dbo].[tblCompany]
	ADD CONSTRAINT [FKTahsilID_tblCompany_tblTahsilMaster]
	FOREIGN KEY (FKTahsilID)
	REFERENCES [tblTahsilMaster] (PKTahsilID)
