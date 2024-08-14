CREATE PROCEDURE [dbo].[uspInsertCountryStateCity]
	@PKID			Bigint,
	@Name1			Varchar(100),
	@Name2			Varchar(100),
	@Name3			Varchar(100),
	@FKCountryID	Bigint,
	@FKStateID		Bigint,
	@FKCityID		Bigint,
	@RecType		Bigint,
	@FKUserID		Bigint,
	@FKPageID		Bigint=0,
	@IPAddress		Varchar(50)
	
AS
Begin
	Declare @ErrorCount Bigint=0
	Declare @Result Bigint=1
	Declare @Msg Varchar(200)=''
	Declare @Operation Varchar(500)
	Declare @Count Bigint=0
	AddTran:
	BEGIN TRANSACTION
	BEGIN TRY
		

		if(@RecType=1)
		Begin
			Select @count=COUNT(*) From tblCountryMaster Where CountryName=@Name1 and PKCountryID<>@PKID
			if(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Country Already Exists!'
			End
			If(@Result=1)
			Begin
					IF(@PKID=0)
					Begin
						Exec uspGetNewID 'tblCountryMaster','PKCountryID',@PKID output
						Insert into tblCountryMaster(PKCountryID,CountryName) Values(@PKID,@Name1)
					End
					Else
					Begin
						Update tblCountryMaster Set CountryName=@Name1 Where PKCountryID=@PKID
					End			End

		End
		Else if(@RecType=2)
		Begin
			Select @count=COUNT(*) From tblStateMaster Where StateName=@Name1 And FKCountryID=@FKCountryID and PKStateID<>@PKID
			if(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='State Already Exists!'
			End
			If(@Result=1)
			Begin
					IF(@PKID=0)
					Begin
						Exec uspGetNewID 'tblStateMaster','PKStateID',@PKID output
						Insert into tblStateMaster(PKStateID,FKCountryID,StateName,StateCode,TraficCode) Values(@PKID,@FKCountryID,@Name1,@Name2,@Name3)
						
					End
					Else
					Begin
						Update tblStateMaster Set FKCountryID=@FKCountryID,StateName=@Name1,StateCode=@Name2,TraficCode=@Name3 Where PKStateID=@PKID
					End
			End
		End
		Else if(@RecType=3)
		Begin
			Select @count=COUNT(*) From tblCityMaster Where CityName=@Name1 And FKStateID=@FKStateID and PKCityID<>@PKID
			if(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='City Already Exists!'
			End
			If(@Result=1)
			Begin
					IF(@PKID=0)
					Begin
						Exec uspGetNewID 'tblCityMaster','PKCityID',@PKID output
						Insert into tblCityMaster(PKCityID,CityName,FKStateID) Values(@PKID,@Name1,@FKStateID)
						
					End
					Else
					Begin
						Update tblCityMaster Set FKStateID=@FKStateID,CityName=@Name1 Where PKCityID=@PKID
					End
			End
		End
		Else if(@RecType=4)
		Begin
			Select @count=COUNT(*) From tblTahsilMaster Where TahsilName=@Name1 And FKCityID=@FKCityID and PKTahsilID<>@PKID
			if(@Count>0)
			Begin
				Set @Result=0
				Set @Msg='Tahsil Or County Already Exists!'
			End
			If(@Result=1)
			Begin
					IF(@PKID=0)
					Begin
						Exec uspGetNewID 'tblTahsilMaster','PKTahsilID',@PKID output
						Insert into tblTahsilMaster(PKTahsilID,TahsilName,FKCityID) Values(@PKID,@Name1,@FKCityID)
						
					End
					Else
					Begin
						Update tblTahsilMaster Set FKCityID=@FKCityID,TahsilName=@Name1 Where PKTahsilID=@PKID
					End
			End
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
			Exec sp_InsertErrorLog @FKUserID,'SP',@SPName,@Msg,@IPAddress
			select @Result as Result,@Msg as Msg
	END CATCH
End