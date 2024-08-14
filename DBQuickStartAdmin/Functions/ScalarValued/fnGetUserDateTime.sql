CREATE FUNCTION [dbo].[fnGetUserDateTime]
(
	@UTCTime DateTime,
	@FKTimeZoneID Bigint
)
RETURNS Datetime
AS
BEGIN
	Declare @AddMin Bigint=0
	if(@FKTimeZoneID=0)
	Begin
			Select @FKTimeZoneID=FKTimezoneID from tblCompany 
	End
	Select @AddMin=OffSet from tblTimeZoneMaster where PKTimeZoneID=@FKTimeZoneID
	RETURN Dateadd(MINUTE,isnull(@AddMin,0),@UTCTime)
END
