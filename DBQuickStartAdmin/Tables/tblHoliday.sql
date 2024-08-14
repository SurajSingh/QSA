CREATE TABLE [dbo].[tblHoliday]
(
	PKID		Bigint Not Null,
	HolidayDate	Date,
	HolidayName Varchar(50),
	HolidayDesc	Varchar(500),
	FKCompanyID	Bigint 
)
