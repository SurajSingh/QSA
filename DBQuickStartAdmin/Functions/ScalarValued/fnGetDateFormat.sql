CREATE FUNCTION [dbo].[fnGetDateFormat]
(
	@DateTime DateTime,
	@DateFormat Varchar(50),
	@Type NChar(2)
)
RETURNS Varchar(20)
AS
BEGIN
	declare @Str Varchar(20)=''
	Declare @Num Int
	if(@DateFormat='MM/dd/yyyy')
	Begin
		Set @Num=101
	End
	Else if(@DateFormat='dd/MM/yyyy')
	Begin
		Set @Num=103
	End
	Else if(@DateFormat='dd-MM-yyyy')
	Begin
		Set @Num=105
	End
	Else if(@DateFormat='MM-dd-yyyy')
	Begin
		Set @Num=110
	End
	Else if(@DateFormat='DateMonthName')
	Begin
		Set @Num=109
	End
	if(@DateTime is not null)
	begin
	if(@Type='D')
	begin
		if(@DateFormat='DateMonthName')
		begin
		set @Str=Convert(Varchar(11),@DateTime,@Num)
		end
		else
		begin
		set @Str=Convert(Varchar(10),@DateTime,@Num)
		end
	end
	else if(@Type='T')
	Begin
	Set @Str=FORMAT(@DateTime,'hh:mm tt')
	End
	else if(@Type='DT')
	Begin
	Set @Str=Convert(Varchar(10),@DateTime,@Num)+' '+FORMAT(@DateTime,'hh:mm tt')
	End
	end
	Return @Str
END
