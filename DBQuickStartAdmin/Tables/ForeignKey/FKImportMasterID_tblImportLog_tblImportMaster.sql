ALTER TABLE [dbo].[tblImportLog]
	ADD CONSTRAINT [FKImportMasterID_tblImportLog_tblImportMaster]
	FOREIGN KEY (FKImportMasterID)
	REFERENCES [tblImportMaster] (PKID)
