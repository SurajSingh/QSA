CREATE PROCEDURE [dbo].[uspGetScheduleStatusMaster]
	
AS
Begin
	Select 1 as Result,PKID,StatusTitle From tblScheduleStatus
End