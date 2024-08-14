CREATE PROCEDURE [dbo].[uspGetUserByID]
	@LoginID Varchar(50)
AS
Begin
		Declare @FKUserID Bigint
		Declare @Msg Varchar(50)='Success'
		Declare @Result Bigint=1			

		Select @FKUserID=b.PKUserID From tblUser b	
		Where  b.ActiveStatus='Active' and B.BStatus=1 and B.LoginID=@LoginID

		if(Isnull(@FKUserID,0)>0)
		Begin	
			Select @Result as Result,@Msg as Msg,b.PKUserID,b.FName as Name,
			b.LoginID,b.EmailID
			From tblUser b
			Where b.PKUserID=@FKUserID
		End
		Else
		Begin
			Set @Msg='User not Registered'
			Set @Result=0
			Select @Result as Result,@Msg as Msg
		End

End
