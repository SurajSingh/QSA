CREATE PROCEDURE [dbo].[uspUpdateAppointmentStatus]
	@FKCompanyID		Bigint, 
	@PKID		Bigint,
	@FKStatusID			Varchar(50)
AS
Begin
	Declare @FKIntervalID BIgint
	Update tblAppoinment Set ApproveStatus=@FKStatusID where PKID=@PKID and FKCompanyID=@FKCompanyID
	If(@FKStatusID='Cancelled')
	begin
		Select @FKIntervalID=FKIntervalID From tblAppoinment where PKID=@PKID and FKCompanyID=@FKCompanyID
		Update  tblAppoinment Set FKIntervalID=Null  where PKID=@PKID and FKCompanyID=@FKCompanyID
		Update tblAppointmentAvailability Set IsUsed=0 where PKID=@FKIntervalID
	end

	Select 1 as Result,'' as Msg
End
