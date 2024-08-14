ALTER TABLE [dbo].[tblProjectDetail]
	ADD CONSTRAINT [FKProjectID_tblProjectDetail_tblProject]
	FOREIGN KEY (FKProjectID)
	REFERENCES [tblProject] (PKID)
