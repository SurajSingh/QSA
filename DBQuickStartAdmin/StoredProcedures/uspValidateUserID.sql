CREATE PROCEDURE [dbo].[uspValidateUserID]
	@LoginID Varchar(50),
	@PKUserID Bigint
AS
Begin
	Declare @count bigint
	If(NULLIF(@LoginID, '') IS NULL)
	Begin
		Select @count=count(PKUserID) From tblUser Where PKUserID=@PKUserID
		if(@count=0)
		begin
			select 0 as Result,'Does not Exist!' as Msg
		end
		else
		begin
			Select 1 as Result			
		end
	End
	else Begin
		Select @count=count(PKUserID) From tblUser Where LoginID=@LoginID and PKUserID<>@PKUserID
		if(@count=0)
		begin
			Select 1 as Result
		end
		else
		begin
			select 0 as Result,'Already Exist!' as Msg
		end
	End	
	
End