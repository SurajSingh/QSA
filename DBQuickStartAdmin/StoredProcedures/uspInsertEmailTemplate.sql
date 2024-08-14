CREATE PROCEDURE [dbo].[uspInsertEmailTemplate]
	@FKCompanyID			Bigint, 
	@FKEmailMsgLocID		Bigint, 		
	@BodyContent			NVarchar(max),
	@EmailSubject			NVarchar(2000),
	@EnableEmail			Bit,	
	@Receiver				Varchar(2000)
	
	
	
AS
Begin
	If Exists(Select FKCompanyID From tblEmailTemplate where FKCompanyID=@FKCompanyID And FKEmailMsgLocID=@FKEmailMsgLocID )
	Begin
		Update tblEmailTemplate Set BodyContent=@BodyContent,EnableEmail=@EnableEmail,EmailSubject=@EmailSubject,Receiver=@Receiver
		Where FKCompanyID=@FKCompanyID And FKEmailMsgLocID=@FKEmailMsgLocID 
	End
	Else
	Begin
		Insert Into tblEmailTemplate(FKCompanyID,FKEmailMsgLocID,BodyContent,EmailSubject,EnableEmail, Receiver)
		Values(@FKCompanyID,@FKEmailMsgLocID,@BodyContent,@EmailSubject,@EnableEmail, @Receiver)
	End

	Select 1 as Result,'' as Msg

End
