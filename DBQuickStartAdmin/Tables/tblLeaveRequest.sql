CREATE TABLE [dbo].[tblLeaveRequest]
(
	PKID				Bigint Not Null,
	FromDate			Date,
	ToDate				Date,
	FKEmpID				Bigint, 
	FKLeaveID			Bigint, 
	LeaveCount			Decimal(18,2),
	Remarks				Varchar(500),
	FKCompanyID			Bigint, 
	ApproveStatus		Varchar(50),
	RejectReason		Varchar(500),
	FKApproveBy			Bigint, 
	FKCreatedBy		    Bigint,	 
	FKLastModifiedBy       Bigint,	
	CreationDate	        DateTime,
	ModificationDate       DateTime,	


)
