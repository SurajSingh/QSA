Create FUNCTION [dbo].[FunRemoveDataType]
(
	@Name Varchar(max),
	@Result Varchar(1)
)
RETURNS Varchar(max)
AS
BEGIN
	
Set @Name=REPLACE(@Name,CHAR(13)+CHAR(10),' ')
If(@Result='d')
Begin
	if(@Name Like '%Varchar%')
	Set @Name='string'
	Else if(@Name Like '%datetime%')
	Set @Name='object'
	Else if(@Name Like '%date%')
	Set @Name='object'
	Else if(@Name Like '%time%')
	Set @Name='object'
	Else if(@Name Like '%bigint%')
	Set @Name='Int64'
	Else if(@Name Like '%int%')
	Set @Name='Int32'
	Else if(@Name Like '%decimal%')
	Set @Name='decimal'
	Else if(@Name Like '%bit%')
	Set @Name='bool'
End
Else
Begin
	If(@Name like '%Varchar%')
	Begin
		Set @Name=SUBSTRING(@Name,0,CHARINDEX('Varchar',@Name)-1)		 
	End
	Else If(@Name like '%bigint%')
	Begin
		Set @Name=SUBSTRING(@Name,0,CHARINDEX('bigint',@Name)-1)		 
	End
	Else If(@Name like '%decimal%')
	Begin
		Set @Name=SUBSTRING(@Name,0,CHARINDEX('decimal',@Name)-1)		 
	End
	Else If(@Name like '%bit%')
	Begin
		Set @Name=SUBSTRING(@Name,0,CHARINDEX('bit',@Name)-1)		 
	End
	Else If(@Name like '% datetime%')
	Begin
		Set @Name=SUBSTRING(@Name,0,CHARINDEX(' datetime',@Name)-1)		 
	End
	Else If(@Name like '% date%')
	Begin
		Set @Name=SUBSTRING(@Name,0,CHARINDEX(' date',@Name)-1)		 
	End
	Else If(@Name like '% time%')
	Begin
		Set @Name=SUBSTRING(@Name,0,CHARINDEX(' time',@Name)-1)		 
	End
	Set @Name=replace(@Name,'@','')
	Set @Name=replace(@Name,' ','')
	Set @Name=LTRIM(@Name)
	Set @Name=RTRIM(@Name)
End	
	RETURN @Name
END
