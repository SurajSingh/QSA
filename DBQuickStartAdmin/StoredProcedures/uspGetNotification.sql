CREATE PROCEDURE [dbo].[uspGetNotification]
	@FKUserID Bigint,
	@FKCompanyID Bigint
AS
Begin
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	

	
	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID

	
	Select A.PKID,dbo.fnGetDateFormat(DisplayDate,@DateForStr,'D') as DisplayDate,LEFT(A.Title,50) as Title,Case when len(a.Announcement)>50 then LEFT (a.Announcement, 50)+'...' Else a.Announcement End as Announcement,Isnull(B.FKAnnouncementID,0) as IsRead From tblAnnouncement A
	Left Join tblAnnouncementNotification B on B.FKAnnouncementID=A.PKID and B.FKUserID=@FKUserID
	Where A.FKCompanyID=@FKCompanyID  and ActiveStatus='Active'
	Order By A.CreationDate Desc

	Declare @FromDate Date=DateAdd(Day,-1,GetDate())
	Declare @ToDate Date=DateAdd(Day,15,GetDate())

	exec uspGetClientScheduleDetail 0,0,'','',1,@FromDate,@ToDate,0,@FKCompanyID,@FKUserID,'','',0,0,''

	Select convert(bit,0) as IsAnnouncement
	Select convert(bit,0) as IsSchedue


End