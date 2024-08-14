ALTER TABLE [dbo].[tblImportUserDef]
	ADD CONSTRAINT [FKLastModifiedBy_tblImportUserDef_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
