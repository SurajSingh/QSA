ALTER TABLE [dbo].[tblUser]
	ADD CONSTRAINT [OrgTypeID_tblUser_tblOrgType]
	FOREIGN KEY (OrgTypeID)
	REFERENCES [tblOrgType] (PKTypeID)
