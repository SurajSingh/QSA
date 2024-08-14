CREATE TABLE [dbo].[tblAppointmentAvailability]
(
	PKID					Bigint Not Null,
	FKEmpID					Bigint,
	OnDate					Date,
	FromTime				Time,	
	ToTime					Time,
	AMinutes				Bigint,	
	IsUsed					Bit Default 0,
	FKCompanyID				Bigint,
	FKCreatedBy				Bigint,	
	FKLastModifiedBy		Bigint,	
	CreationDate			DateTime	Not Null,
	ModificationDate		DateTime,	
    BStatus					BIT   Default 1 
)
