CREATE PROCEDURE [dbo].[uspInsertAppointment]
	@PKID					Bigint,
	@FKEmpID				BIgint,
	@FKIntervalID			Bigint,
	@OnDate					Date,
	@FromTime				Time,	
	@ToTime					Time,	
	@CutomerName			Varchar(50),
	@CompanyName			Varchar(50),
	@EmailID				Varchar(50),
	@Mobile					Varchar(50),
	@Remarks				NVarchar(max),
	@ApproveStatus			Varchar(50),
    @FKCompanyID			Bigint, 
	@FKUserID				Bigint,	
	@FKPageID				Bigint=0,
	@IPAddr					Varchar(50)
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
		Declare @FKPIntervalID Bigint=0
		Declare	@FromTime1					Time	
		Declare @ToTime1					Time
		Declare @OnDate1					Date

		if(@Result=1 and @PKID<>0)
		Begin
			Select @Count=count(*) from tblAppoinment where PKID=@PKID and BStatus=1  and FKCompanyID=@FKCompanyID
			If(@Count=0)
			Begin
				Set @Result=0
				Set @Msg='Invalid Operation!'
			End
		End
		
		if(@Result=1)
		Begin
			Select @Count=count(*) from tblAppointmentAvailability where PKID=@FKIntervalID and BStatus=1 and IsUsed=1  and FKCompanyID=@FKCompanyID
			If(@PKID<>0)
			Begin
				Select @FKPIntervalID=FKIntervalID From tblAppoinment Where PKID=@PKID
			End
			If(@Count>0)
			Begin
				If(@FKPIntervalID<>@FKIntervalID)
				Begin
					Set @Result=0
					Set @Msg='Selected interval is already used!'
				End
			End
		End		
		
		If(@Result=1)
		Begin
			Select @Count=count(*) from tblAppointmentAvailability where PKID=@FKIntervalID and BStatus=1   and FKCompanyID=@FKCompanyID
			and Cast(OnDate as datetime)+Cast(FromTime as datetime)>Cast(OnDate as datetime)+Cast(@FromTime as datetime)

			If(@Count>0)
			Begin
					Set @Result=0
					Set @Msg='From time should not be before available interval'
			End
			Else
			Begin
				Select @Count=count(*) from tblAppointmentAvailability where PKID=@FKIntervalID and BStatus=1   and FKCompanyID=@FKCompanyID
				and Cast(OnDate as datetime)+Cast(ToTime as datetime)<Cast(OnDate as datetime)+Cast(@ToTime as datetime)
				If(@Count>0)
				Begin
					Set @Result=0
					Set @Msg='To time should not be after available interval'
				End
			End


		End


		
		If(@Result=1)
		Begin			
			
			Select @FromTime1=FromTime,@ToTime1=ToTime,@OnDate1=OnDate From  tblAppointmentAvailability where PKID=@FKIntervalID
			Declare @Date1 Datetime=Cast(@ondate1 as datetime)+Cast(@FromTime1 as datetime)
			Declare @Date2 Datetime=Cast(@ondate as datetime)+Cast(@FromTime as datetime)

			Declare @NewFromTime Time
			Declare @NewToTime Time
			Declare @NewMinutes Bigint
			Declare @PKDetailID Bigint=0	

			If(DATEDIFF(MINUTE,@Date1,@Date2)>=10)
			Begin
				
				
				Set @NewFromTime=@FromTime1
				Set @NewToTime=@Date2
				
				Set @PKDetailID=0
					
				Exec uspGetNewID 'tblAppointmentAvailability','PKID',@PKDetailID output,0
				
				Insert Into tblAppointmentAvailability(PKID,FKEmpID,OnDate,FromTime, ToTime, AMinutes,IsUsed, BStatus, FKCompanyID, FKCreatedBy, CreationDate)
			    Select @PKDetailID,@FKEmpID,@OnDate1,@NewFromTime, @NewToTime, DATEDIFF(MINUTE, @NewFromTime, @NewToTime),0, 1, @FKCompanyID,
			    @FKUserID, GETUTCDATE()

			End
			

			Set  @Date1=Cast(@ondate1 as datetime)+Cast(@ToTime1 as datetime)
			Set @Date2 =Cast(@ondate as datetime)+Cast(@ToTime as datetime) 

			If(@Date2<@Date1)
			Begin
				If(DATEDIFF(MINUTE,@Date2,@Date1)>=10)
				Begin
					Set @NewMinutes=DATEDIFF(MINUTE,@Date2,@Date1)
					Set @NewFromTime=@Date2				
					Set @NewToTime=Cast(@Date1 as Time)


					Set @PKDetailID=0
					
					Exec uspGetNewID 'tblAppointmentAvailability','PKID',@PKDetailID output,0
				
					Insert Into tblAppointmentAvailability(PKID,FKEmpID,OnDate,FromTime, ToTime, AMinutes,IsUsed, BStatus, FKCompanyID, FKCreatedBy, CreationDate)
					Select @PKDetailID,@FKEmpID,@OnDate1,@NewFromTime, @NewToTime, DATEDIFF(MINUTE, @NewFromTime, @NewToTime),0, 1, @FKCompanyID,
					 @FKUserID, GETUTCDATE()				

				End
			End
			
			Update tblAppointmentAvailability Set IsUsed=1,FromTime=@FromTime,ToTime=@ToTime where PKID=@FKIntervalID


			
			If(@PKID=0)
			Begin
				Exec uspGetNewID 'tblAppoinment','PKID',@PKID output
				Insert Into tblAppoinment(PKID,FKEmpID, FKIntervalID, OnDate, FromTime,ToTime,TotalMinutes,CutomerName,CompanyName,EmailID,Mobile,Remarks,ApproveStatus, FKCompanyID, FKCreatedBy, FKLastModifiedBy, CreationDate, ModificationDate, BStatus)
				Values(@PKID,@FKEmpID, @FKIntervalID, @OnDate, @FromTime,@ToTime,DATEDIFF(MINUTE, @FromTime, @ToTime),@CutomerName,@CompanyName,@EmailID,@Mobile,@Remarks,@ApproveStatus, @FKCompanyID, @FKUserID, null, GETUTCDATE(), null, 1)				
				
				Set @Operation='New  Appointment Added'
			End
			Else
			Begin			
					
				Update tblAppoinment Set FKEmpID=@FKEmpID, FKIntervalID=@FKIntervalID, OnDate=@OnDate, FromTime=@FromTime,
				ToTime=@ToTime,TotalMinutes=DATEDIFF(MINUTE, @FromTime, @ToTime),CutomerName=@CutomerName,CompanyName=@CompanyName,
				
				EmailID=@EmailID,Mobile=@Mobile,Remarks=@Remarks,ApproveStatus=@ApproveStatus, FKLastModifiedBy=@FKUserID, ModificationDate=GETUTCDATE()
				Where PKID=@PKID				

				Set @Operation='Appointment Updated'
			End
			
			
		End		

	--Insert Log
	if(@Result=1)
	Begin
		Exec uspInsertLog @FKUserID,@FKPageID,@IPAddr,@Operation,@PKID
	End
	Select @Result as Result,@Msg as Msg,@PKID as PKID,@ApproveStatus as ApproveStatus
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


