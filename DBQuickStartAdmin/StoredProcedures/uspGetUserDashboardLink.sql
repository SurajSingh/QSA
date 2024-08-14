CREATE PROCEDURE [dbo].[uspGetUserDashboardLink]
@FKUserID	Bigint,
@FKCompanyID Bigint,
@RoleType Varchar(20)
AS
Begin
	Create Table #tmpDashboardLink(
		ID					Bigint Identity(1,1) not Null,
		SNo					Bigint,
		LinkName			Varchar(50),
		LinkDescription		Varchar(500),
		IconHTML			Varchar(50),
		FKPageID			Bigint,
		LinkURL				Varchar(50),
	
	
	)
	Declare @FKRoleGroupID Bigint=0
	
	Declare @OrgTypeID	Varchar(2)
	Select @FKRoleGroupID=FKRoleGroupID,@OrgTypeID=OrgTypeID From tblUser where PKUserID=@FKUserID


	Insert Into #tmpDashboardLink
	Select SNo,LinkName,LinkDescription,IconHTML,FKPageID,'' From tblDashboardLink
	where FKPageID in (Select PKPageID
	from tblPageMaster
	Where BStatus=1 
	And (PKPageID in (Select lnk.FKPageID from tblPageRoleLnk lnk Where lnk. FKRoleID in (Select FKRoleID From tblRoleGroupLnk Where FKRoleGroupID=@FKRoleGroupID and BStatus=1)	
	
	) Or IsNull(@FKRoleGroupID,0)=0 )
	and RecType Like '%'+@OrgTypeID+'%')


	Declare @Start Bigint=1
	Declare @End Bigint=0
	Declare @Str Varchar(max)=''
	Declare @LinkURL Varchar(50)
	Declare @FKPageID Bigint=1

	Select @End=max(ID) From #tmpDashboardLink

	If(Isnull(@End,0)>0)
	Begin
			While @Start<=@End
			Begin
			Select @FKPageID=FKPageID From #tmpDashboardLink where ID=@Start
			Set @LinkURL=''
			Select Top 1 @LinkURL=PageLink From tblPageMaster where (PKPageID=@FKPageID Or FKParentID=@FKPageID)
			And IsPageLink=1 Order By SNo

			Set @LinkURL=Isnull(@LinkURL,'')
			If(@LinkURL<>'')
			Begin
				Update #tmpDashboardLink Set LinkURL=@LinkURL Where ID=@Start
			End
			


			Set @Start=@Start+1
			End
	End


Select top 4 * FRom #tmpDashboardLink
Order by SNo

End
