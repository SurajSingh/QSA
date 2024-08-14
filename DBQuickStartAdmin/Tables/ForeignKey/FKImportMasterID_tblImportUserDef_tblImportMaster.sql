ALTER TABLE [dbo].[tblImportUserDef]
	ADD CONSTRAINT [FKImportMasterID_tblImportUserDef_tblImportMaster]
	FOREIGN KEY (FKImportMasterID)
	REFERENCES [tblImportMaster] (PKID)
