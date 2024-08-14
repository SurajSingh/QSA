CREATE PROCEDURE [dbo].[uspGetEmailTemplate]
	@FKCompanyID			Bigint, 
	@FKEmailMsgLocID		Bigint
	
AS
Begin
	Select 1 as Result,FKEmailMsgLocID, BodyContent, EmailSubject, EnableEmail,Isnull(Receiver,'') as Receiver,dbo.fnGetReceiverEmail(Receiver) as ReceiverEmail 
	From tblEmailTemplate Where FKCompanyID=@FKCompanyID And FKEmailMsgLocID=@FKEmailMsgLocID 
	Exec uspGetEmailSettings @FKCompanyID
End
