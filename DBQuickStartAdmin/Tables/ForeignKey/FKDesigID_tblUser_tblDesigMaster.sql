ALTER TABLE [dbo].[tblUser]
	ADD CONSTRAINT [FKDesigID_tblUser_tblDesigMaster]
	FOREIGN KEY (FKDesigID)
	REFERENCES [tblDesigMaster] (PKDesigID)
