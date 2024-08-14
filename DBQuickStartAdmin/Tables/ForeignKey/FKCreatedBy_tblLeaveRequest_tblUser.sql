ALTER TABLE [dbo].[tblLeaveRequest]
	ADD CONSTRAINT [FKCreatedBy_tblLeaveRequest_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
