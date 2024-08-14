CREATE PROCEDURE [dbo].[uspGetParty]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@PKID				Bigint,
	@FKCompanyID		Bigint,
	@Company			Varchar(50)	
	
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	
	Set @StrQry=N'Select RCount = COUNT(*) OVER(),1 as Result,A.PKID,A.Code,A.Company,A.CPerson,A.CPersonTitle,A.Notes,A.Address1,A.Address2,Isnull(A.FKTahsilID,0) as FKTahsilID, Isnull(A.FKCityID,0) as FKCityID, Isnull(A.FKStateID,0) as FKStateID, Isnull(A.FKCountryID,0) as FKCountryID,A.ZIP,A.EMailID,A.Phone1,A.Phone2,A.Mobile,A.Fax,A.Website,
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 	
	Isnull(ADC.CountryName,'''') as CountryName,Isnull(ADS.StateName,'''') as StateName,ISnull(ADC1.CityName,'''') as CityName,ISnull(ADT.TahsilName,'''') as TahsilName,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName
	From tblPartyMaster A	
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID	
	Left Join tblCountryMaster ADC on A.FKCountryID=ADC.PKCountryID
	Left Join tblStateMaster ADS on A.FKStateID=ADS.PKStateID
	Left Join tblCityMaster ADC1 on A.FKCityID=ADC1.PKCityID
	Left Join tblTahsilMaster ADT on A.FKTahsilID=ADT.PKTahsilID
	Where (A.PKID=@PKID or @PKID=0)
	And (A.Code Like ''%''+@Company+''%'' Or @Company='''' Or A.Company Like ''%''+@Company+''%'')
	And (A.FKCompanyID=@FKCompanyID)	'
	
		If(@SortBy='')
		Begin
			Set @SortBy='A.Code,A.Company'
		End		
		Else If(@SortBy='Code')
		Begin
			Set @SortBy='A.Code'
		End
		Else If(@SortBy='Company')
		Begin
			Set @SortBy='A.Company'
		End
		Else If(@SortBy='CPerson')
		Begin
			Set @SortBy='A.CPerson'
		End
		
		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
		End
		

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@PKID Bigint,@FKCompanyID	Bigint,@Company Varchar(50),@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@PKID,@FKCompanyID,@Company,@DateForStr,@FKTimezoneID

	

End
