Create PROCEDURE [dbo].[uspGetNewID]
@TableName Varchar(100),
@ColName Varchar(100),
@NewID Bigint Output,
@FKDeviceID	Bigint=0
AS
Begin

	Declare @StrQry nVarchar(1000)
	Declare @ParmDefinition nVarchar(1000)

	Declare @Min Bigint=0
	Declare @Max Bigint=0
	Set @Min=Isnull(@FKDeviceID,0)*5000000
	Set @Max=(Isnull(@FKDeviceID,0)+1)*5000000


	Set @StrQry='Select @NewID=ISnull(max('+@ColName+'),0)+1 From '+@TableName+' Where '+@ColName+'>'+CONVERT(Varchar(50),@Min)+' And '+@ColName+'<'+CONVERT(Varchar(50),@Max)
	SET @ParmDefinition = N'@NewID Bigint OUTPUT'

	EXEC sp_executesql @StrQry, @ParmDefinition, @NewID=@NewID OUTPUT
Return
End


