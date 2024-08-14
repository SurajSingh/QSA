ALTER TABLE [dbo].[tblTaskAssignment]
	ADD CONSTRAINT [FKProjectForecastingID_tblTaskAssignment_tblProjectModule]
	FOREIGN KEY (FKProjectForecastingID)
	REFERENCES [tblProjectModule] (PKID)
