ALTER TABLE [dbo].[tblEmpGroup]
	ADD CONSTRAINT [FKCreatedBy_tblEmpGroup_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
