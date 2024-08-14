ALTER TABLE [dbo].[tblCompanyPages]
	ADD CONSTRAINT [FKPageID_tblCompanyPages_tblPageMaster]
	FOREIGN KEY (FKPageID)
	REFERENCES [tblPageMaster] (PKPageID)
