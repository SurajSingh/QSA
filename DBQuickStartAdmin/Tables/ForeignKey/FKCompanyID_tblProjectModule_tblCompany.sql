ALTER TABLE dbo.tblProjectModule
	ADD CONSTRAINT [FKCompanyID_tblProjectModule_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
