CREATE FUNCTION [dbo].[FunGetProjectModuleEmp]
(
	@FKID		Bigint
)
RETURNS Varchar(max)    
AS    
BEGIN    
 declare @Str Varchar(max)=''    
     
 Select @Str= @Str+' '+B.FName+' '+B.LName+',' From tblTaskAssignment A    
 Inner Join tblUser B on A.FKEmpID=B.PKUserID    
 Where A.FKProjectForecastingID=@FKID    
 SET @Str = REPLACE(REPLACE(@Str + '<END>', ',<END>', ''), '<END>', '')  
SET @Str = REPLACE(REPLACE('<BEGIN>'+@Str , '<BEGIN>,', ''), '<BEGIN>', '')   
     
 Return @Str    
END 