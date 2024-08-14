ALTER TABLE [dbo].[tblLeaveRequest]
	ADD CONSTRAINT [FKApproveBy_tblLeaveRequest_tblUser]
	FOREIGN KEY (FKApproveBy)
	REFERENCES [tblUser] (PKUserID)
