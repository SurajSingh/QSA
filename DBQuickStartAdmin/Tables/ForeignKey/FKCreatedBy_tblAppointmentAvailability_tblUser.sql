ALTER TABLE [dbo].[tblAppointmentAvailability]
	ADD CONSTRAINT [FKCreatedBy_tblAppointmentAvailability_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
