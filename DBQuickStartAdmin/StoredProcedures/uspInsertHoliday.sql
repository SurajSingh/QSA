CREATE PROCEDURE [dbo].[uspInsertHoliday]
	@PKID			Bigint,
	@HolidayDate	Date,
	@HolidayName	Varchar(50),
	@HolidayDesc	Varchar(500),
	@FKCompanyID	Bigint,
	@FKUserID	    Bigint,
	@FKPageID	    Bigint=0,
	@IPAddress	    Varchar(50)
	
AS
Begin
	Declare @Result Bigint=1
	DEclare @Msg Varchar(50)=''
	Declare @Count Bigint

	Select @Count=Count(*) From tblHoliday Where PKID<>@PKID and FKCompanyID=@FKCompanyID and HolidayName=@HolidayName

	If(@Count>0)
	Begin
		Set @Result=0
		Set @Msg='Holiday already exists'
	End

	If(@Result=1)
	Begin
		Select @Count=Count(*) From tblHoliday Where PKID<>@PKID and FKCompanyID=@FKCompanyID and HolidayDate=@HolidayDate

		If(@Count>0)
		Begin
			Set @Result=0
			Set @Msg='Holiday already exists on selected date'
		End
	End

	If(@Result=1)
	Begin
		If(@PKID=0)
		Begin
			Exec uspGetNewID 'tblHoliday','PKID',@PKID output
			Insert Into tblHoliday(PKID,HolidayDate,HolidayName,HolidayDesc,FKCompanyID) Values(@PKID,@HolidayDate,@HolidayName,@HolidayDesc,@FKCompanyID)

		End
		Else
		Begin
			Update tblHoliday Set HolidayName=@HolidayName,HolidayDesc=@HolidayDesc,HolidayDate=@HolidayDate
			Where PKID=@PKID

		End


	End

	Select @Result as Result, @Msg as Msg

End
