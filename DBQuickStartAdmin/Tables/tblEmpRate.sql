CREATE TABLE [dbo].[tblEmpRate]
(	
    [FKUserID]         Bigint, 
    [BillRate]         DECIMAL (18, 2) NULL,
    [PayRate]          DECIMAL (18, 2) NULL,
    [OverTimeBillRate] DECIMAL (18, 2) NULL,
    [OverTimePayrate]  DECIMAL (18, 2) NULL,
    [OverheadMulti]    DECIMAL (18, 2) NULL,
    FKCurrencyID		Bigint, 
    [PayPeriod]        VARCHAR (50)    NULL,
    [SalaryAmount]     DECIMAL (18, 2) NULL 
    
)
