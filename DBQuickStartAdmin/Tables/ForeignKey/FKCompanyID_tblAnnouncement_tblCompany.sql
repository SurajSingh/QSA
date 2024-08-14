ALTER TABLE [dbo].[tblAnnouncement]
	ADD CONSTRAINT [FKCompanyID_tblAnnouncement_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
