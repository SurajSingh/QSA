CREATE PROCEDURE [dbo].[sp_InsertErrorLog]
	@FKUserID Bigint,
	@ErrorType Varchar(5),
	@ErrorModule Varchar(100)='',
	@ErrorDesc NVarchar(2000)='',
	@IPAddress Varchar(50)=''
AS
Begin
		Insert Into tblErrorLogs(FKUserID,ErrorType,ErrorModule,ErrorDesc,IPAddress,CreationDate)
		Values(@FKUserID,@ErrorType,@ErrorModule,@ErrorDesc,@IPAddress,getdate())
End