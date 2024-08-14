ALTER TABLE [dbo].[tblEmpRate]
	ADD CONSTRAINT [FKUserID_tblEmpRate_tblUser]
	FOREIGN KEY (FKUserID)
	REFERENCES [tblUser] (PKUserID)
