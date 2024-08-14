CREATE TABLE [dbo].[tblDeptMaster]
(
	PKDeptID	Bigint			Not Null,
	DeptName	Varchar(50)		Not Null,
	FKManagerID	Bigint	Not Null, 
	DeptDesc	Varchar(200)	Not Null,	
	FKCompanyID	Bigint,	
	FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime	Not Null,
	ModificationDate	DateTime,
	BStatus		Bit				Default 1
)
