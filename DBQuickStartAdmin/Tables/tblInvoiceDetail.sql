CREATE TABLE [dbo].[tblInvoiceDetail]
(
	PKID		Bigint Identity(1,1) Not Null,
	FKID		Bigint, 
	Itemtype	Varchar(50),
	ItemPKID	Bigint,
	ItemDesc	Nvarchar(2000),
	Rate		Decimal(18,4),
	Qty			Decimal(18,4),
	Amount		Decimal(18,4)
)
