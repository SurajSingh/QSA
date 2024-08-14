Create PROCEDURE [dbo].[uspGetTableLayout]
	@FKPageID				Bigint,
	@TableID				Varchar(50),
	@FKCompanyID			Bigint,
	@FKUserID				Bigint
AS
Begin
		Declare @XMLDef XML=null
		IF Exists(Select PKID From tblTableLayout
		Where FKCompanyID=@FKCompanyID And FKPageID=@FKPageID And TableID=@TableID And IsNull(FKUserID,0)=Isnull(@FKUserID,0) And ForAllUser=0 And FKUserID Is Not Null)
		Begin
				Select @XMLDef=XMLDef From tblTableLayout Where FKCompanyID=@FKCompanyID And FKPageID=@FKPageID And TableID=@TableID And IsNull(FKUserID,0)=Isnull(@FKUserID,0) And FKUserID Is Not Null And  ForAllUser=0
				
		End
		Else IF Exists(Select PKID From tblTableLayout
		Where FKCompanyID=@FKCompanyID And FKPageID=@FKPageID And TableID=@TableID  And ForAllUser=1)
		Begin
				Select @XMLDef=XMLDef From tblTableLayout Where FKCompanyID=@FKCompanyID And FKPageID=@FKPageID And TableID=@TableID  And ForAllUser=1
				
		End

		Else
		Begin
			Select @XMLDef=XMLDef From tblTableLayout Where FKCompanyID=@FKCompanyID And FKPageID=@FKPageID And TableID=@TableID And FKUserID is null
		End
	If(@XMLDef is not null)
	Begin
		Select 
		@TableID as TableID,
		AddData.value('SNo[1]', 'Bigint') AS SNo,
		AddData.value('FieldName[1]', 'Varchar(50)') AS FieldName,
		AddData.value('HeaderName[1]','Varchar(50)') AS HeaderName,
		AddData.value('DisplayName[1]','Varchar(50)') AS DisplayName,
		AddData.value('AutoFocus[1]', 'Bit') AS AutoFocus,
		AddData.value('Readonly[1]', 'Bit') AS [Readonly],
		AddData.value('Visibility[1]', 'Bit') AS Visibility,
		AddData.value('ShowOnLayOutPage[1]', 'Bit') AS ShowOnLayOutPage,		
		AddData.value('Editable[1]', 'Bit') AS Editable,
		AddData.value('IsPrint[1]', 'Bit') AS IsPrint,
		AddData.value('ColWidth[1]', 'Varchar(50)') AS ColWidth
		FROM    @XMLDef.nodes('NewDataSet/Table1') as X (AddData)
		Order By AddData.value('SNo[1]', 'Bigint')
	End
End
