CREATE PROCEDURE [dbo].[uspGetPrintLayout]
	@FKCompanyID Bigint,
	@FKTranTypeID Bigint
AS
Begin
	Select FKTranTypeID,PageWidth,PageHeight,MarLeft,MarRight,MarTop,MarBottom From tblPrintLayout
	Where FKCompanyID=@FKCompanyID and FKTranTypeID=@FKTranTypeID

End
