ALTER TABLE [dbo].[tblLeaveRequest]
	ADD CONSTRAINT [FKCompanyID_tblLeaveRequest_tblCompany]
	FOREIGN KEY (FKCompanyID)
	REFERENCES [tblCompany] (PKCompanyID)
