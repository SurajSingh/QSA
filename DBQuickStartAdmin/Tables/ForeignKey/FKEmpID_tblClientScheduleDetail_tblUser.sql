ALTER TABLE [dbo].[tblClientScheduleDetail]
	ADD CONSTRAINT [FKEmpID_tblClientScheduleDetail_tblUser]
	FOREIGN KEY (FKEmpID)
	REFERENCES [tblUser] (PKUserID)
