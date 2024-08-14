ALTER TABLE [dbo].[tblAppointmentAvailability]
	ADD CONSTRAINT [FKLastModifiedBy_tblAppointmentAvailability_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
