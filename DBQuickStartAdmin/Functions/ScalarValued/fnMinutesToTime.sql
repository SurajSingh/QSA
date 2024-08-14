CREATE FUNCTION [dbo].[fnMinutesToTime]
(
    @minutes int 
)
RETURNS nvarchar(30)

AS
BEGIN
declare @hours  nvarchar(20)
declare @num Bigint
if(@minutes>=60)
Begin
    Set @num=@minutes/60
    If(@num<10)
    Set @hours='0'+Convert(varchar(50),@num)
    Else
    Set @hours=@num

    If(@minutes%60>0)
    Begin
        Set @hours=@hours+':'+Case when @minutes%60<10 then '0'+convert(varchar(50),@minutes%60) Else convert(varchar(50),@minutes%60) End
    End
    Else
    Set @hours=@hours+':00'
    

End
Else
Begin
    Set @hours='00:'+Case when @minutes<10 then '0'+convert(varchar(50),@minutes) Else convert(varchar(50),@minutes) End
End




return @hours
END