ALTER TABLE [dbo].[tblTimeSheet]
	ADD CONSTRAINT [FKProjectID_tblTimeSheet_tblProject]
	FOREIGN KEY (FKProjectID)
	REFERENCES [tblProject] (PKID)
