CREATE FUNCTION [dbo].[FunGetScheduledEmp]
(
	@FKID		Bigint
)
RETURNS Varchar(max)    
AS    
BEGIN    
 declare @Str Varchar(max)=''    
     
 Select @Str= @Str+' '+B.FName+' '+B.LName+',' From tblClientScheduleDetail A    
 Inner Join tblUser B on A.FKEmpID=B.PKUserID    
 Where A.FKID=@FKID    
 SET @Str = REPLACE(REPLACE(@Str + '<END>', ',<END>', ''), '<END>', '')  
SET @Str = REPLACE(REPLACE('<BEGIN>'+@Str , '<BEGIN>,', ''), '<BEGIN>', '')   
     
 Return @Str    
END 