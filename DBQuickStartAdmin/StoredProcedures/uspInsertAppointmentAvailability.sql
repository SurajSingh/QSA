CREATE PROCEDURE [dbo].[uspInsertAppointmentAvailability]
	@FKEmpID				Bigint,	
	@dtItem					XML,		
	@FKCompanyID			Bigint,	
	@FKUserID				Bigint,	
	@FKPageID				Bigint=0,
	@IPAddress				Varchar(50),	
	@CallFromSP				Bit
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(max)=''
	Declare @Count Bigint=0
	Declare @Operation Varchar(50)	
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY

			Declare @DateForStr Varchar(50)
			Select @DateForStr=DateForStr From tblCompany Where PKCompanyID=@FKCompanyID
			Declare @Start Bigint=1
			Declare @End Bigint=0

			Declare @OnDate Date
			Declare @FromTime Time
			Declare @ToTime Time
			Declare @ModeForm Bigint
			Declare @PKID Bigint

			Create table #tmpDetail(
				ID						BIGINT Identity(1,1) Not Null,
				 PKID                   BIGINT,	
				 NewPKID                BIGINT,	
				 OnDate					Date,
				 FromTime				Time,	
				 ToTime					Time,	                        
				 ModeForm			    Bigint
			)

			Insert Into #tmpDetail(PKID,NewPKID, OnDate,FromTime,ToTime,ModeForm)			
			SELECT  AddData.value('PKID[1]', 'bigint') AS PKID, 
			0 As NewPKID,
			AddData.value('OnDate[1]', 'Date') AS OnDate,	
			AddData.value('FromTime[1]', 'Time') AS FromTime,	
			AddData.value('ToTime[1]', 'Time') AS ToTime,						
			AddData.value('ModeForm[1]', 'bigint') AS ModeForm
			FROM    @dtItem.nodes('NewDataSet/Detail') as X (AddData)
			
			Select @End=Max(ID) From #tmpDetail

			IF(Isnull(@End,0)>0)
			Begin
				While @Start<=@End
				Begin
					Select @PKID=PKID,@FromTime=FromTime,@ToTime=ToTime,@OnDate=OnDate,@ModeForm=ModeForm From #tmpDetail Where ID=@Start

					If(@ModeForm=0)
					Begin
						Select @Count=count(*) from #tmpDetail 
						where ID<>@Start  and ModeForm=0 						
						And OnDate=@OnDate And  ((FromTime<=@FromTime and ToTime>=@ToTime) or ( ToTime>=@ToTime and FromTime<@ToTime) or (FromTime>@FromTime and ToTime<@ToTime))

						If(@Count>0)
						Begin
							Set @Result=0
							Set @Msg=@Msg+'Interval already exists on date '+dbo.fnGetDateFormat(@OnDate,@DateForStr,'D')+' between '+dbo.fnGetDateFormat(@FromTime,@DateForStr,'T')+' to '++dbo.fnGetDateFormat(@ToTime,@DateForStr,'T')+'<br/>'
						End
						--Else
						--Begin
						--	Select @Count=count(*) from tblAppointmentAvailability 
						--	where PKID<>@PKID  and FKEmpID=@FKEmpID 						
						--	And OnDate=@OnDate And  ((@FromTime>=FromTime and @FromTime<=ToTime) Or (@ToTime>=FromTime and @ToTime<=ToTime))

						--	If(@Count>0)
						--	Begin
						--		Set @Result=0
						--		Set @Msg=@Msg+'Interval already exists on date '+dbo.fnGetDateFormat(@OnDate,@DateForStr,'D')+' between '+dbo.fnGetDateFormat(@FromTime,@DateForStr,'T')+' to '++dbo.fnGetDateFormat(@ToTime,@DateForStr,'T')+'<br/>'
						--	End


						--End

					End

					Set @Start=@Start+1

				End

			End






			
	If(@Result=1)
	Begin
			Declare @PKDetailID Bigint=0		
			Exec uspGetNewID 'tblAppointmentAvailability','PKID',@PKDetailID output,0
			Set @PKDetailID=@PKDetailID-1
				
			Update #tmpDetail Set  @PKDetailID = NewPKID = @PKDetailID + 1		
			Where PKID=0 And ModeForm=0

			Delete From tblAppointmentAvailability
			Where PKID in (Select PKID From #tmpDetail where ModeForm<>0) and FKCompanyID=@FKCompanyID

			Update A Set OnDate=B.OnDate,FromTime=B.FromTime,ToTime=B.ToTime,AMinutes=DATEDIFF(MINUTE, B.FromTime, B.ToTime),FKLastModifiedBy=@FKUserID,ModificationDate=GETUTCDATE()
			From tblAppointmentAvailability A
			Inner Join #tmpDetail B on A.PKID=B.PKID
			Where B.ModeForm=0 and B.PKID<>0
			and A.FKCompanyID=@FKCompanyID
				
			Insert Into tblAppointmentAvailability(PKID,FKEmpID,OnDate,FromTime, ToTime, AMinutes,IsUsed, BStatus, FKCompanyID, FKCreatedBy, CreationDate)
			Select NewPKID,@FKEmpID,OnDate,FromTime, ToTime, DATEDIFF(MINUTE, FromTime, ToTime),0, 1, @FKCompanyID,
			@FKUserID, GETUTCDATE()
			From #tmpDetail
			Where PKID=0 And ModeForm=0

	End
			

	If(@CallFromSP=0)
	Begin
		Select @Result as Result,@Msg as Msg
		
	End

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		
		ROLLBACK TRANSACTION
			
			Set @Result=0
				Set @Msg = ERROR_MESSAGE()	
				Declare @SPName Varchar(200)
				Set @SPName=ERROR_PROCEDURE()	
				Exec sp_InsertErrorLog 0,'SP',@SPName,@Msg,''
				select @Result as Result,@Msg as Msg,ERROR_LINE() as [LineNo],@SPName as SPName
	END CATCH
End


