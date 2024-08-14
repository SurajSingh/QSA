CREATE TABLE [dbo].[tblDashboardLink]
(
	PKID				Bigint Not null,
	SNo					Bigint,
	LinkName			Varchar(50),
	LinkDescription		Varchar(500),
	IconHTML			Varchar(50),
	FKPageID			Bigint

)
