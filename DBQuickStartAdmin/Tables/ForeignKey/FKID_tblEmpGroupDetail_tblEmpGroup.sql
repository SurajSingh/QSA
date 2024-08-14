ALTER TABLE [dbo].[tblEmpGroupDetail]
	ADD CONSTRAINT [FKID_tblEmpGroupDetail_tblEmpGroup]
	FOREIGN KEY (FKID)
	REFERENCES [tblEmpGroup] (PKID)
