CREATE PROCEDURE [dbo].[uspGetUser]
	@PageSize			bigint=0,
	@PageNo				Bigint=0,
	@SortBy				Varchar(200),
	@SortDir			Varchar(50),
	@PKUserID Bigint,
	@Name Varchar(50),
	@FKRoleGroupID Bigint=0,
	@ActiveStatus Varchar(50),
	@FKDeptID Bigint=0,	
	@FKDesigID Bigint=0,
	@FKCompanyID Bigint=0,
	@FKManagerID	Bigint=0,	
	@OrgTypeFilters Varchar(max),
	@ForAppointment	Bit
	
AS
Begin
	Declare @StrQry NVarchar(max)=''
	Declare @ParmDefinition nVarchar(max)=''
	Declare @DateForStr Varchar(50)
	Declare @FKTimezoneID Bigint	
	Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID
	
	
	Set @StrQry=N'Select RCount = COUNT(*) OVER(),1 as Result,A.PKUserID, A.LoginID, A.EmailID, A.PWD, A.FName, A.MName, A.LName,dbo.fnGetDateFormat(A.DOB,@DateForStr,''D'') as DOB, A.Gender, A.MobNo, A.Phone1, A.Phone2, 
	A.Address1, A.Address2, Isnull(A.FKTahsilID,0) as FKTahsilID, Isnull(A.FKCityID,0) as FKCityID, Isnull(A.FKStateID,0) as FKStateID, Isnull(A.FKCountryID,0) as FKCountryID, A.ZIP,
	Isnull(ADC.CountryName,'''') as CountryName,Isnull(ADS.StateName,'''') as StateName,ISnull(ADC1.CityName,'''') as CityName,
	ISnull(ADT.TahsilName,'''') as TahsilName, dbo.fnGetDateFormat(A.JoinDate,@DateForStr,''D'') as JoinDate, dbo.fnGetDateFormat(A.ReleasedDate,@DateForStr,''D'') as ReleasedDate, 
	Isnull(A.FKManagerID,0) as FKManagerID, Isnull(A.FKSubmitToID,0) as FKSubmitToID, A.OrgTypeID, A.RoleType, Isnull(A.FKRoleGroupID,0) as FKRoleGroupID, Isnull(A.FKDeptID,0) as FKDeptID, 
	Isnull(A.FKDesigID,0) as FKDesigID, Isnull(A.FKTimezoneID,0) as FKTimezoneID,
	A.IsDefaultUser, A.PhotoURL, Isnull(A.FKDashboardID,0) as FKDashboardID, A.ActiveStatus, 
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.CreationDate,@FKTimezoneID),@DateForStr,''D'') as CreationDate,	
	dbo.fnGetDateFormat(dbo.fnGetUserDateTime(A.ModificationDate,@FKTimezoneID),@DateForStr,''D'') as ModificationDate, 
	A.EnrollNo, A.AddressTitle, A.Remark, A.IsAppointment,
	ISnull(B.DeptName,'''') as DeptName,ISnull(C.DesigName,'''') as DesigName,
	Isnull(A1.FName,'''') as ManagerName,
	Isnull(A2.FName,'''') as SubmitToName,
	Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,
	ER.[BillRate], ER.[PayRate], ER.[OverTimeBillRate], ER.[OverTimePayrate], ER.[OverheadMulti], ER.[FKCurrencyID], ER.[PayPeriod], ER.[SalaryAmount]
	From tblUser A
	Left Join tblDeptMaster B on A.FKDeptID=B.PKDeptID
	Left Join tblDesigMaster C on A.FKDesigID=C.PKDesigID
	Left Join tblRoleGroup D on A.FKRoleGroupID=D.PKRoleGroupID
	Left Join tblDashboard E on A.FKDashboardID=E.PKID
	Left Join tblCountryMaster ADC on A.FKCountryID=ADC.PKCountryID
	Left Join tblStateMaster ADS on A.FKStateID=ADS.PKStateID
	Left Join tblCityMaster ADC1 on A.FKCityID=ADC1.PKCityID
	Left Join tblTahsilMaster ADT on A.FKTahsilID=ADT.PKTahsilID
	Left Join tblOrgType OT on A.OrgTypeID=OT.PKTypeID
	Left Join tblUser A1 on A.FKManagerID=A1.PKUserID
	Left Join tblUser A2 on A.FKSubmitToID=A2.PKUserID
	Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID
	Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID
	Left Join tblEmpRate ER on ER.FKUserID=A.PKUserID
	Where A.BStatus=1 And (A.ActiveStatus=@ActiveStatus Or @ActiveStatus='''')
	And (A.FName+'' ''+A.LName Like ''%''+@Name+''%'' Or A.LoginID Like ''%''+@Name+''%'' Or @Name='''')
	And (A.FKCompanyID=@FKCompanyID Or @FKCompanyID=0)	
	And (A.PKUserID=@PKUserID or @PKUserID=0)
	And (A.FKDeptID=@FKDeptID Or @FKDeptID=0)
	And (A.FKDesigID=@FKDesigID Or @FKDesigID=0)
	And (A.FKRoleGroupID=@FKRoleGroupID Or @FKRoleGroupID=0)
	And (A.FKManagerID=@FKManagerID Or @FKManagerID=0)
	And (Isnull(A.IsAppointment,0)=Case When @ForAppointment=1 then 1 Else Isnull(A.IsAppointment,0) End)
	And (@OrgTypeFilters='''' Or A.OrgTypeID in (Select Item From dbo.FunSplitString(@OrgTypeFilters,'',''))) '
	
	
		If(@SortBy='')
		Begin
			Set @SortBy='A.FName,A.ActiveStatus'
		End		
		Else If(@SortBy='CreationDate')
		Begin
			Set @SortBy='A.CreationDate'
		End
		
		Set @StrQry=@StrQry+' Order By '+@SortBy+Case When @SortDir='D' then ' Desc' Else ' Asc' End	
	
		if(@PageSize>0)
		Begin
				Set @StrQry=@StrQry+' OFFSET @PageNo ROW FETCH NEXT @PageSize ROWS ONLY '
		End
		IF(@PKUserID<>0)
		Begin
		
		Set @StrQry=@StrQry+N' 
		Select [FKUserID], [BillRate], [PayRate], [OverTimeBillRate], [OverTimePayrate], [OverheadMulti], [FKCurrencyID], [PayPeriod], [SalaryAmount] From tblEmpRate where FKUserID=@PKUserID
		Select PKID,GroupName,Description From tblEmpGroup where PKID in (Select FKID From tblEmpGroupDetail where FKEmpID=@PKUserID) and FKCompanyID=@FKCompanyID
		'

		
		End

	SET @ParmDefinition = N'@PageSize bigint,@PageNo Bigint,@SortBy	Varchar(50),@SortDir Varchar(50),@PKUserID Bigint,@Name Varchar(50),@FKRoleGroupID Bigint,@ActiveStatus Varchar(50),@FKDeptID Bigint,@FKDesigID Bigint,@FKCompanyID Bigint,@FKManagerID Bigint,	@OrgTypeFilters Varchar(max),@ForAppointment Bit,@DateForStr Varchar(50),@FKTimezoneID Bigint'
	EXEC sp_executesql @StrQry, @ParmDefinition,@PageSize ,@PageNo ,@SortBy,@SortDir,@PKUserID,@Name,@FKRoleGroupID,@ActiveStatus,@FKDeptID,@FKDesigID,@FKCompanyID,@FKManagerID,@OrgTypeFilters,@ForAppointment,@DateForStr,@FKTimezoneID

	
End
	