ALTER TABLE [dbo].[tblAppointmentAvailability]
	ADD CONSTRAINT [FKCompanyID_tblAppointmentAvailability_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
