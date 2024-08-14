ALTER TABLE [dbo].[tblProjectGroupDetail]
	ADD CONSTRAINT [FKProjectID_tblProjectGroupDetail_tblProject]
	FOREIGN KEY (FKProjectID)
	REFERENCES [tblProject] (PKID)
