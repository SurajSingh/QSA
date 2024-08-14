CREATE TABLE [dbo].[tblClientScheduleDetail]
(
	PKID	Bigint Identity(1,1) Not Null,
	FKID	Bigint,
	FKEmpID	Bigint,
	IsRead  Bit Default 0
)
