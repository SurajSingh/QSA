CREATE FUNCTION [dbo].[FunGetProjectModuleParent]
(
    @PKID               BIgint,
	@FKProjectID		Bigint,
    @DownLine           Varchar(max)
)
RETURNS Varchar(max)    
AS    
BEGIN    
 declare @Str Varchar(max)=''    
   
Select @Str=@Str+'<span>'+B.ModuleName+'</span>' FRom dbo.FunSplitString(@DownLine,'-') A
Inner Join tblProjectModule B on A.Item=B.SNo and B.FKProjectID=@FKProjectID
where A.Item<>'' and B.PKID<>@PKID   
     
 Return @Str    
END 