CREATE PROCEDURE [dbo].[uspLogin]
	@LoginID Varchar(50),
	@PWD Varchar(200),
	@IPAddress Varchar(50),
	@MACAddress Varchar(50)

AS
Begin
		Declare @PKID Bigint=0
		Declare @FKUserID Bigint
		Declare @Msg Varchar(50)='Success'
		Declare @Result Bigint=1	
		Declare @UserToken Varchar(50)=''


		Select @FKUserID=b.PKUserID From tblUser b	
		Where  b.ActiveStatus='Active' and B.BStatus=1 and B.LoginID=@LoginID and B.PWD=@PWD

		if(Isnull(@FKUserID,0)>0)
		Begin
			Exec uspInsertLog @FKUserID,0,@IPAddress,'Login',0
			
			Select @UserToken= COnvert(Varchar(20),@PKID)+'-'+CONVERT(VARCHAR(30), RIGHT(NEWID(), 30))
			
			Update tblUser Set LastLoginDate=GETUTCDATE(),UserToken=@UserToken where PKUserID=@FKUserID
			
			Select @Result as Result,@Msg as Msg,b.UserToken,b.PKUserID,b.RoleType,b.FName as Name, b.emailID,
			b.LoginID,b.FKRoleGroupID,b.FKCompanyID,b.FKRoleGroupID,b.PhotoURL,C.CompanyName,C.DateForStr,C1.PKCurrencyID,C1.Symbol,B.OrgTypeID,OT.OrgType
			From tblUser b
			Left join tblCompany C on B.FKCompanyID=C.PKCompanyID		
			Left Join tblCurrencyMaster C1 on C.FKCurrencyID=C1.PKCurrencyID
			Left Join tblOrgType OT on B.OrgTypeID=OT.PKTypeID
			Where b.PKUserID=@FKUserID

		End
		Else
		Begin
			Set @Msg='Invalid Login ID Or Password'
			Set @Result=0
			Select @Result as Result,@Msg as Msg
		End

End

