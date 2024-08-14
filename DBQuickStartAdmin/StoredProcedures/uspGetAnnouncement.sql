CREATE PROCEDURE [dbo].[uspGetAnnouncement]
@PKID			    Bigint,
@FKDisplay			Bigint,
@ForRead			Bigint,
@FKUserID			Bigint,
@FKCompanyID	    Bigint
AS
Begin
	
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Declare @count bigint
	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID

	

	Select 1 as Result,PKID,Title,dbo.fnGetDateFormat(DisplayDate,@DateForStr,'D') as DisplayDate,Announcement,ActiveStatus
	From tblAnnouncement Where FKCompanyID=@FKCompanyID
	And (PKID=@PKID Or @PKID=0)	
	And (@FKDisplay=0 Or ActiveStatus='Active')
	Order By DisplayDate Desc

	if(@ForRead=1)
	begin
		Select @count=Count(*) from tblAnnouncementNotification where FKAnnouncementID=@PKID and FKUserID=@FKUserID
		if(@count=0)
		begin

			Insert Into tblAnnouncementNotification(FKUserID,FKAnnouncementID) Values(@FKUserID,@PKID)
		End

	end

End
