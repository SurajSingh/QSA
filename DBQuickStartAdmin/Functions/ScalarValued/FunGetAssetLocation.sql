CREATE FUNCTION [dbo].[FunGetAssetLocation]
(
@FKLocationID Varchar(50),
@EmpName Varchar(50),
@DeptName Varchar(50),
@VendorName Varchar(50)
)
RETURNS Varchar(max)
AS
BEGIN
Declare @str Varchar(max)=''

If(@FKLocationID=1)
Set @str=@EmpName
Else If(@FKLocationID=2)
Set @str=@DeptName
Else If(@FKLocationID=3)
Set @str='Store'
Else If(@FKLocationID=4)
Set @str=@VendorName



	RETURN @str
END
