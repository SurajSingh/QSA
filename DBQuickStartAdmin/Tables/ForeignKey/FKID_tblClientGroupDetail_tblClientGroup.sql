ALTER TABLE [dbo].[tblClientGroupDetail]
	ADD CONSTRAINT [FKID_tblClientGroupDetail_tblClientGroup]
	FOREIGN KEY (FKID)
	REFERENCES [tblClientGroup] (PKID)
