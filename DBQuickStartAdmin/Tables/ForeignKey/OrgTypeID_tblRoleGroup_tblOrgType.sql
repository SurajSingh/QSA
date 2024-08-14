ALTER TABLE [dbo].[tblRoleGroup]
	ADD CONSTRAINT [OrgTypeID_tblRoleGroup_tblOrgType]
	FOREIGN KEY (OrgTypeID)
	REFERENCES [tblOrgType] (PKTypeID)
