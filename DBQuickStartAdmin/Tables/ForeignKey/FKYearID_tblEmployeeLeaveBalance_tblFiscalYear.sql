ALTER TABLE [dbo].[tblEmployeeLeaveBalance]
	ADD CONSTRAINT [FKYearID_tblEmployeeLeaveBalance_tblFiscalYear]
	FOREIGN KEY (FKYearID)
	REFERENCES [tblFiscalYear] (PKID)
