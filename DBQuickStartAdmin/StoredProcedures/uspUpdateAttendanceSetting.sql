CREATE PROCEDURE [dbo].[uspUpdateAttendanceSetting]
	@FKCompanyID		Bigint, 
	@AttenUserName		Varchar(50),
	@AttenPWD			Varchar(50)
AS
Begin
	Update tblCompany Set AttenUserName=@AttenUserName,AttenPWD=@AttenPWD
	Where PKCompanyID=@FKCompanyID

	Select 1 as Result,'' as Msg
End