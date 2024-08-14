CREATE PROCEDURE [dbo].[uspInsertClientSchedule]
	@PKID               BIGINT,
	@FKProjectID		Bigint, 
	@FromDate			Date,
	@ToDate				Date,
	@FromTime			Time,
	@FKWorkTypeID		Bigint, 
	@FKStatusID			Bigint, 
	@Remarks			NVarchar(2000),	
	@StrEmp				Varchar(max),
    @FKCompanyID		 Bigint, 
	@FKUserID			 Bigint,	
	@FKPageID		     Bigint=0,
	@IPAddr			     Varchar(50)
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(max)=''
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		
		

		Declare @Count Bigint=0
		Declare @Operation Varchar(100)=''
		

		if(@Result=1 and @PKID<>0)
		Begin
			Select @Count=count(*) from tblClientSchedule where PKID=@PKID and BStatus=1  and FKCompanyID=@FKCompanyID
			If(@Count=0)
			Begin
				Set @Result=0
				Set @Msg='Invalid Operation!'
			End
		End
		
		if(@Result=1)
		Begin
			Select @Count=count(*) from tblClientScheduleDetail A
			Inner Join tblClientSchedule B on A.FKID=B.PKID
			where (B.PKID<>@PKID) and B.FKStatusID<>3  and BStatus=1  and FKCompanyID=@FKCompanyID
			and A.FKEmpID in (Select Item From dbo.FunSplitString(@StrEmp,',') where Item<>'')
			And ((@FromDate>=B.FromDate and @FromDate<=B.ToDate) Or (@ToDate>=B.FromDate and @ToDate<=B.ToDate))
			If(@Count>0)
			Begin
				Set @Result=0
				
				Select @Msg=@Msg+'<li>Employee <b>'+U.FName+' '+U.LName+'</b> is already scheduled on <b>'+P.ProjectCode+'</b> on given date</li>' from tblClientScheduleDetail A
				Inner Join tblClientSchedule B on A.FKID=B.PKID
				Inner Join tblUser U on A.FKEmpID=U.PKUserID
				Inner Join tblProject P on B.FKProjectID=B.PKID
				where (B.PKID<>@PKID) and B.FKStatusID<>3  and B.BStatus=1  and B.FKCompanyID=@FKCompanyID
				and A.FKEmpID in (Select Item From dbo.FunSplitString(@StrEmp,',') where Item<>'')
				And ((@FromDate>=B.FromDate and @FromDate<=B.ToDate) Or (@ToDate>=B.FromDate and @ToDate<=B.ToDate))

				Set @Msg='<ul>'+@Msg+'</ul>'
			End
		End
		
		If(@Result=1)
		Begin			
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblClientSchedule','PKID',@PKID output
				Insert Into tblClientSchedule(PKID, FKProjectID, FromDate, ToDate, FromTime, FKWorkTypeID, FKStatusID, Remarks, FKCompanyID, FKCreatedBy, FKLastModifiedBy, CreationDate, ModificationDate, BStatus)
				Values(@PKID, @FKProjectID, @FromDate, @ToDate, @FromTime, @FKWorkTypeID, @FKStatusID, @Remarks, @FKCompanyID, @FKUserID, null, GETUTCDATE(), null, 1)				
				
				Set @Operation='New  Client Schedule Added'
			End
			Else
			Begin
			
				
				Update tblClientSchedule Set FKProjectID=@FKProjectID, FromDate=@FromDate, ToDate=@ToDate, FromTime=@FromTime, FKWorkTypeID=@FKWorkTypeID, FKStatusID=@FKStatusID, Remarks=@Remarks, FKLastModifiedBy=@FKUserID, ModificationDate=GETUTCDATE()
				Where PKID=@PKID

				Delete From tblClientScheduleDetail where FKID=@PKID

				Set @Operation='Client Schedule Updated'
			End

			Insert Into tblClientScheduleDetail(FKID, FKEmpID)
			Select @PKID,Item From dbo.FunSplitString(@StrEmp,',') where Item<>''
			
		End		

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddr,@Operation,@PKID
	End
	Select @Result as Result,@Msg as Msg
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH		
			ROLLBACK TRANSACTION
			Set @Result=0
			Set @Msg = ERROR_MESSAGE()	
			Declare @SPName Varchar(200)
			Set @SPName=ERROR_PROCEDURE()	
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddr
			select @Result as Result,@Msg as Msg
	END CATCH
End

