CREATE PROCEDURE [dbo].[uspGetImportFields]
@PKID Bigint
AS
Begin
Declare @XMLDef XML=null
Select @XMLDef=ImportCols from tblImportMaster 
Where PKID=@PKID

		Select 
		AddData.value('SNo[1]', 'Bigint') AS SNo,
		AddData.value('FieldName[1]', 'Varchar(50)') AS FieldName,		
		AddData.value('DisplayName[1]','Varchar(50)') AS DisplayName,
		AddData.value('DataType[1]', 'Varchar(50)') AS DataType,
		AddData.value('IsRequired[1]', 'bit') AS [IsRequired],
		AddData.value('DefaultVal[1]', 'Varchar(50)') AS DefaultVal,
		AddData.value('PreFix[1]', 'Varchar(50)') AS PreFix		
		FROM    @XMLDef.nodes('NewDataSet/Table1') as X (AddData)
		Order By AddData.value('SNo[1]', 'Bigint')

End
