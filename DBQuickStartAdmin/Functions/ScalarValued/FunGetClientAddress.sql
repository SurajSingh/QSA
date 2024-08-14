CREATE FUNCTION [dbo].[FunGetClientAddress]
(
	@FKClientID	Bigint,
	@RecType Varchar(50)
)
RETURNS Varchar(max)
AS
BEGIN
declare @address varchar(max)=''
declare @street2 varchar(500)='' 
declare @street varchar(500)='', @city varchar(50)='', @state varchar(50)='', @country varchar(50)='', @zip varchar(50)=''           

If(@RecType='C')
Begin
Select @street=Address1,@street2=Address2,@city=isnull(ADC1.CityName,''),@state=isnull(ADS.StateName,''),@country=isnull(ADC.CountryName,''),@zip=A.ZIP
From tblClient A 
Left Join tblCountryMaster ADC on A.FKCountryID=ADC.PKCountryID
Left Join tblStateMaster ADS on A.FKStateID=ADS.PKStateID
Left Join tblCityMaster ADC1 on A.FKCityID=ADC1.PKCityID
Left Join tblTahsilMaster ADT on A.FKTahsilID=ADT.PKTahsilID
where A.PKID=@FKClientID
End


if(@street<>'')          
begin          
 set @address = @address+@street          
end     
if(@street2<>'')          
begin    
 if(@street<>'')    
 begin    
 set @address=@address   
 end          
 set @address = @address+@street2           
end          
          
if(@address <>'')          
begin          
 set @address = @address           
end          
          
if(@city<>'')          
begin          
 set @address = @address +'<br/>'+ @city          
end          
          
        
          
if(@state<>'')          
begin        
 if(@city <>'')          
 begin          
 set @address = @address + ', '          
 end      
      
  set @address = @address + @state          
end          
          
        
          
if(@country!='')          
begin     
       
  set @address = @address+'<br/>' + @country          
end          
          
        
          
if(@zip !='')          
begin          
 set @address = @address +' ' +@zip          
end          
        
         


RETURN @address
END
