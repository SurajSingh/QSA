ALTER TABLE [dbo].[tblTableLayout]
	ADD CONSTRAINT [FKPageID_tblTableLayout_tblPageMaster]
	FOREIGN KEY (FKPageID)
	REFERENCES [tblPageMaster] (PKPageID)
