CREATE FUNCTION [dbo].[fnGetReceiverEmail]
(
@StrEmp Varchar(max)
)
RETURNS Varchar(max)    
AS    
BEGIN    
 declare @Str Varchar(max)=''    
     
 Select @Str= @Str+B.EmailID+',' From dbo.FunSplitString(@StrEmp,',') A    
 Inner Join tblUser B on A.Item=B.PKUserID    
 Where A.Item<>'' and B.EmailID<>'' 
 SET @Str = REPLACE(REPLACE(@Str + '<END>', ',<END>', ''), '<END>', '')  
SET @Str = REPLACE(REPLACE('<BEGIN>'+@Str , '<BEGIN>,', ''), '<BEGIN>', '')   
     
 Return @Str    
END 