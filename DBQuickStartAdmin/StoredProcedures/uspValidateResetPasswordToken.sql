CREATE PROCEDURE [dbo].[uspValidateResetPasswordToken]
	@ResetPwdTokenID Varchar(50)
AS
Begin
	Declare @count bigint = 0
	
	Select @count=1 From tblUser Where ResetPwdToken=@ResetPwdTokenID and ActiveStatus='Active' and BStatus=1 
	if(@count=1)
	begin
		Select 1 as Result, '' as Msg
	end
	else
	begin
		select 0 as Result,'Invalid token!' as Msg
	end
End