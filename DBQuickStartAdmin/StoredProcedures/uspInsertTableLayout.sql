CREATE PROCEDURE [dbo].[uspInsertTableLayout]
	
	@FKPageID			Bigint,
	@TableID				Varchar(50),
	@XMLDef				XML,
	@FKCompanyID			Bigint,
	@FKUserID			Bigint,
	@ForAllUser			Bit=0,
	@IsReset			Bit=0
AS
Begin
		Declare @Count Bigint
		Select @Count=count(*) From tblTableLayout
		Where FKCompanyID=@FKCompanyID And FKPageID=@FKPageID And TableID=@TableID And IsNull(FKUserID,0)=Isnull(@FKUserID,0)
		If(@FKUserID=0)
		Set @FKUserID=Null

		If(@FKCompanyID=0)
		Set @FKCompanyID=Null

		If(@FKPageID=0)
		Set @FKPageID=Null
		
		if(@IsReset=1)
		Begin
			Delete From tblTableLayout Where FKCompanyID=@FKCompanyID And FKPageID=@FKPageID And TableID=@TableID And FKUserID=@FKUserID
			if(@ForAllUser=1)
			Begin
				Delete From tblTableLayout Where FKCompanyID=@FKCompanyID And FKPageID=@FKPageID And TableID=@TableID And (FKUserID Is Not Null Or ForAllUser=1)
			End
		End
		Else
		Begin

			If(@ForAllUser=1 And IsNull(@FKUserID,0)<>0)
			Begin
				Delete From tblTableLayout Where FKCompanyID=@FKCompanyID And FKPageID=@FKPageID And TableID=@TableID And (FKUserID Is Not Null Or ForAllUser=1)
				Set @FKUserID=Null
				Set @Count=0			
			End
			Else if(@ForAllUser=0)
			Begin
				Delete From tblTableLayout Where FKCompanyID=@FKCompanyID And FKPageID=@FKPageID And TableID=@TableID And FKUserID=@FKUserID
			End
		
			Insert Into tblTableLayout(FKPageID,TableID,XMLDef,FKCompanyID,FKUserID,CreationDate,ForAllUser)
			Values(@FKPageID,@TableID,@XMLDef,@FKCompanyID,@FKUserID,GETUTCDATE(),@ForAllUser)


			
		End
		Select 1 as Result
End
