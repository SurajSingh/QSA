CREATE PROCEDURE [dbo].[uspUpdateScheduleStatus]
	@FKCompanyID		Bigint, 
	@PKID		Bigint,
	@FKStatusID			Bigint
AS
Begin
	Update tblClientSchedule Set FKStatusID=@FKStatusID where PKID=@PKID and FKCompanyID=@FKCompanyID
	Select 1 as Result,'' as Msg
End
