CREATE FUNCTION [dbo].[FunSplitString]
(	@psCSString VARCHAR(max),    
	@seperator varchar(1) 
)
RETURNS @otTemp TABLE(ID bigint, Item VARCHAR(2000))    
AS    
BEGIN    
 DECLARE @sTemp VARCHAR(500)  
 Declare @ID bigint=1  
    
 WHILE LEN(@psCSString) > 0    
 BEGIN    
  SET @sTemp = LEFT(@psCSString, ISNULL(NULLIF(CHARINDEX(@seperator, @psCSString) - 1, -1),    
                    LEN(@psCSString)))    
  SET @psCSString = SUBSTRING(@psCSString,ISNULL(NULLIF(CHARINDEX(@seperator, @psCSString), 0),    
                               LEN(@psCSString)) + 1, LEN(@psCSString))    
  INSERT INTO @otTemp VALUES (@ID,replace(@sTemp,' ',''))   
  set @ID=@ID+1 
 END    
    
RETURN    
END