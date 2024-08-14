ALTER TABLE [dbo].[tblEmpGroup]
	ADD CONSTRAINT [FKLastModifiedBy_tblEmpGroup_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
