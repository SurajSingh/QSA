CREATE PROCEDURE [dbo].[uspGetInvForAdjustment]
	@PKID			Bigint,
	@FKClientID		Bigint,
	@FKProjectID	Bigint,
	@FKCompanyID	Bigint

AS
Begin
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID

	Select Case When Isnull(Adj1.FKPaymentID,0)=0 then COnvert(Bit,0) Else  COnvert(Bit,1) End as IsSelected,A.PKID,
	dbo.fnGetDateFormat(A.InvDate,@DateForStr,'D') as InvDate, 
	P.ProjectCode,P.ProjectName,
	A.FKProjectID, A.InvoiceID,A.NetAmount,A.NetDueAmount+Isnull(Adj1.Amount,0) as NetDueAmount,Isnull(Adj1.Amount,0) as AdjAmt FRom 
	tblInvoice A Inner Join tblProject P on A.FKProjectID=P.PKID
	Inner Join tblClient C on P.FKClientID=C.PKID
	Outer Apply (Select Adj.FKPaymentID,Adj.Amount FRom tblInvAdjustment Adj where Adj.FKPaymentID=@PKID and Adj.FKInvoiceID=A.PKID) as Adj1
	Where A.FKCompanyID=@FKCompanyID
	And (P.FKClientID=@FKClientID or @FKClientID=0)
	And (A.FKProjectID=@FKProjectID Or @FKProjectID=0)
	And A.NetDueAmount+Isnull(Adj1.Amount,0)>0
	Order By A.SNo
End