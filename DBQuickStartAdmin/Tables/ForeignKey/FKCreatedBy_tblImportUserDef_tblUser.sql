ALTER TABLE [dbo].[tblImportUserDef]
	ADD CONSTRAINT [FKCreatedBy_tblImportUserDef_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
