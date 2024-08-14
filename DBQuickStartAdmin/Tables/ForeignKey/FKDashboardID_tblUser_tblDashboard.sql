ALTER TABLE [dbo].[tblUser]
	ADD CONSTRAINT [FKDashboardID_tblUser_tblDashboard]
	FOREIGN KEY (FKDashboardID)
	REFERENCES [tblDashboard] (PKID)
