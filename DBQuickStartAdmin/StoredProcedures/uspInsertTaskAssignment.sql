CREATE PROCEDURE [dbo].[uspInsertTaskAssignment]
	@FKEmpID				Bigint,
	@FKManagerID			Bigint,
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
	Declare @Msg Varchar(200)=''
	Declare @Count Bigint=0
	Declare @Operation Varchar(50)	
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY



			Create table #tmpDetail(
				 PKID                   BIGINT,
				 NewPKID                BIGINT,
				 AssignDate             Date,
                 FKTaskID               Bigint,                
				 FKProjectID            Bigint, 
				 BHrs                   DECIMAL (18,2),
                 Description            NVARCHAR (2000),    
				 Remark					NVARCHAR (2000),    
				 ModeForm			    Bigint
			)

			Insert Into #tmpDetail(PKID,NewPKID, AssignDate, FKTaskID,FKProjectID, BHrs, Description, Remark,ModeForm)			
			SELECT  AddData.value('PKID[1]', 'bigint') AS PKID, 
			0 As NewPKID,
			AddData.value('AssignDate[1]', 'Date') AS TaskDate,	
			AddData.value('FKTaskID[1]', 'bigint') AS FKTaskID,	
			AddData.value('FKProjectID[1]', 'bigint') AS FKProjectID,		
			AddData.value('BHrs[1]', 'DECIMAL (18,2)') AS Hrs,	
			AddData.value('Description[1]', ' NVARCHAR (2000)') AS Description,	
			AddData.value('Remark[1]', ' NVARCHAR (4000)') AS Remark,			
			AddData.value('ModeForm[1]', 'bigint') AS ModeForm
			FROM    @dtItem.nodes('NewDataSet/Detail') as X (AddData)
			Left Join tblTask A On AddData.value('FKTaskID[1]', 'bigint')=A.PKID
			Left Join tblTimeSheet T On AddData.value('PKID[1]', 'bigint')=T.PKID
			Left Join tblProject P On AddData.value('FKProjectID[1]', 'bigint')=P.PKID
			Left Join tblClient C On P.FKClientID=C.PKID

			
			Declare @PKDetailID Bigint=0		
			Exec uspGetNewID 'tblTaskAssignment','PKID',@PKDetailID output,0
			Set @PKDetailID=@PKDetailID-1
				
			Update #tmpDetail Set  @PKDetailID = NewPKID = @PKDetailID + 1		
			Where PKID=0 And ModeForm=0
				
			Insert Into tblTaskAssignment(PKID,FKCompanyID,AssignDate,FKTaskID, FKEmpID, FKProjectID, BHrs, Description, Remark, FKManagerID,TimeTaken,	FKCreatedBy, CreationDate)
			Select NewPKID,@FKCompanyID,AssignDate,FKTaskID, @FKEmpID, FKProjectID, BHrs, Description,Remark,@FKManagerID,0 ,
			@FKUserID, GETUTCDATE()
			From #tmpDetail
			Where PKID=0 And ModeForm=0

			

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


