ALTER TABLE [dbo].[tblProjectGroupDetail]
	ADD CONSTRAINT [FKID_tblProjectGroupDetail_tblProjectGroup]
	FOREIGN KEY (FKID)
	REFERENCES [tblProjectGroup] (PKID)
