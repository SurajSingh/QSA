ALTER TABLE [dbo].[tblPageRoleLnk]
	ADD CONSTRAINT [FKPageID_tblPageRoleLnk_tblPageMaster]
	FOREIGN KEY (FKPageID)
	REFERENCES [tblPageMaster] (PKPageID)