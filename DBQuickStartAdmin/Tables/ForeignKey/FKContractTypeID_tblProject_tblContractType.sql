ALTER TABLE [dbo].[tblProject]
	ADD CONSTRAINT [FKContractTypeID_tblProject_tblContractType]
	FOREIGN KEY (FKContractTypeID)
	REFERENCES [tblContractType] (PKID)
