CREATE PROCEDURE [dbo].[uspGetTimezoneID]
	
AS
Begin
	Select PKTimeZoneID, replace(DisplayName,'''','') as DisplayName, OffSet from tblTimeZoneMaster 

End
