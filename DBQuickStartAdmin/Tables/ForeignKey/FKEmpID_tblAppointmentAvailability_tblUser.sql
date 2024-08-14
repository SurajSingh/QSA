ALTER TABLE [dbo].[tblAppointmentAvailability]
	ADD CONSTRAINT [FKEmpID_tblAppointmentAvailability_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
