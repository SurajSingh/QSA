ALTER TABLE [dbo].[tblAppoinment]
	ADD CONSTRAINT [FKIntervalID_tblAppoinment_tblAppointmentAvailability]
	FOREIGN KEY (FKIntervalID)
	REFERENCES [tblAppointmentAvailability] (PKID)
