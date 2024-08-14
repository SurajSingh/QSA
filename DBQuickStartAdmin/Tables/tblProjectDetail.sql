CREATE TABLE [dbo].[tblProjectDetail]
(
	FKProjectID		    Bigint Not Null,  
    FKCurrencyID         Bigint,
    ISCustomInvoice     Bit Default 0,
    InvoicePrefix       VARCHAR (50),
    InvoiceSuffix       VARCHAR (50),
    InvoiceSNo          BIGINT ,
	FKBillingFrequency  Bigint,
    GRT                 DECIMAL (18, 2),
    ExpenseTax          DECIMAL (18, 2),
    FKTaxID             Bigint, 
    FKTermID            Bigint,  
    TBillable           Bit Default 0,
    TMemoRequired       Bit Default 0,
    EBillable           Bit Default 0,
    EMemoRequired       Bit Default 0,    
    TDesReadonly        Bit Default 0,
    EDesReadOnly        Bit Default 0
     
)
