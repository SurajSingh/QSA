CREATE FUNCTION [dbo].[FunGetInvoiceDueonDate]
(
	@PKID	Bigint,
	@DateWise Bit,
	@OnDate Date,
	@InvDueAmt Decimal(18,4),
	@RecType Varchar(50)
)
RETURNS Decimal(18,4)
AS
BEGIN
	Declare @Amount Decimal(18,4)=0
	Declare @DueAmount Decimal(18,4)=0

	Select @Amount=Sum(A.Amount) From tblInvAdjustment A Inner Join tblPayment B on A.FKPaymentID=B.PKID
	Where A.FKInvoiceID=@PKID And (B.TranDate<=@OnDate Or @DateWise=0)

	Set @Amount=Isnull(@Amount,0)
	If(@RecType='Due')
	Begin
		Set @Amount=@InvDueAmt-@Amount
	End



	Return @Amount
END
