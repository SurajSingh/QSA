alter PROCEDURE [dbo].[uspGetTimesheetEntry]  
 @TaskName    varchar(100),  
 @TaskCode    varchar(100),  
 @TaskDate    varchar(20),  
 @ProjectCode   varchar(100),
 @EmpID int
AS  
Begin  
 Declare @StrQry NVarchar(max)=''  
 Declare @ParmDefinition nVarchar(max)=''  
 --Declare @DateForStr Varchar(50)  
 --Declare @FKTimezoneID Bigint   
 --Select @DateForStr=DateForStr,@FKTimezoneID=FKTimezoneID From tblCompany Where PKCompanyID=@FKCompanyID  
   
 if(@EmpID = -1 )
 Begin
	Set @StrQry=N' Select RCount = COUNT(*) OVER(),1 as Result,A.PKID, A.TaskDate, A.FKTaskID, A.FKEmpID, A.FKProjectID, A.Hrs, A.Description, A.IsBillable,   
 A.Memo, A.TBHours, A.TCostRate, A.TBillRate, Isnull(A.FKAssignLogID,0) as FKAssignLogID, Isnull(A.FKSubmitToID,0) as FKSubmitToID, A.ApproveStatus,   
 A.ApproveDate, A.IsBilled, Isnull(A.FKInvoiceID,0) as FKInvoiceID, A.TaskStatus,    
 C.ProjectCode,C.ProjectName,Isnull(C2.TMemoRequired,0) as TMemoRequired,Isnull(C2.TDesReadonly,0) as TDesReadonly,  
 D.TaskCode+'':''+D.TaskName as TaskName,D.BHours,C1.Code As ClientCode,C1.Company as ClientName,  
 Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,  
 Isnull(U.FName,'''') as SubmitToName,  
 Isnull(U3.FName,'''') as ApproveByName,  
 Emp.FName,Emp.LName,emp.LoginID  
 From tblTimeSheet A  
   
 Inner Join tblProject C on A.FKProjectID=C.PKID  
 Inner Join tblTask D on A.FKTaskID=D.PKID  
 Left Join tblClient C1 on C.FKClientID=C1.PKID  
 Left Join tblProjectDetail C2 on C2.FKProjectID=C.PKID  
 Left Join tblUser Emp on A.FKEmpID=emp.PKUserID  
 Left Join tblUser U on A.FKSubmitToID=U.PKUserID  
 Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID  
 Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID  
 Left Join tblUser U3 on A.FKApproveByID=U3.PKUserID   
 Where C.ProjectCode = @ProjectCode and d.TaskName=@TaskName and d.TaskCode=@TaskCode   
 and A.TaskDate = @TaskDate'

 SET @ParmDefinition = N'@TaskName Varchar(max),@TaskCode Varchar(max),@TaskDate Varchar(50),@ProjectCode Varchar(50)'  
 EXEC sp_executesql @StrQry, @ParmDefinition,@TaskName ,@TaskCode ,@TaskDate,@ProjectCode  
 End
 else Begin
 Set @StrQry=N' Select RCount = COUNT(*) OVER(),1 as Result,A.PKID, A.TaskDate, A.FKTaskID, A.FKEmpID, A.FKProjectID, A.Hrs, A.Description, A.IsBillable,   
 A.Memo, A.TBHours, A.TCostRate, A.TBillRate, Isnull(A.FKAssignLogID,0) as FKAssignLogID, Isnull(A.FKSubmitToID,0) as FKSubmitToID, A.ApproveStatus,   
 A.ApproveDate, A.IsBilled, Isnull(A.FKInvoiceID,0) as FKInvoiceID, A.TaskStatus,    
 C.ProjectCode,C.ProjectName,Isnull(C2.TMemoRequired,0) as TMemoRequired,Isnull(C2.TDesReadonly,0) as TDesReadonly,  
 D.TaskCode+'':''+D.TaskName as TaskName,D.BHours,C1.Code As ClientCode,C1.Company as ClientName,  
 Isnull(U1.FName,'''') as CreatedByName,Isnull(U2.FName,'''') as ModifiedByName,  
 Isnull(U.FName,'''') as SubmitToName,  
 Isnull(U3.FName,'''') as ApproveByName,  
 Emp.FName,Emp.LName,emp.LoginID  
 From tblTimeSheet A  
   
 Inner Join tblProject C on A.FKProjectID=C.PKID  
 Inner Join tblTask D on A.FKTaskID=D.PKID  
 Left Join tblClient C1 on C.FKClientID=C1.PKID  
 Left Join tblProjectDetail C2 on C2.FKProjectID=C.PKID  
 Left Join tblUser Emp on A.FKEmpID=emp.PKUserID  
 Left Join tblUser U on A.FKSubmitToID=U.PKUserID  
 Left Join tblUser U1 on A.FKCreatedBy=U1.PKUserID  
 Left Join tblUser U2 on A.FKLastModifiedBy=U2.PKUserID  
 Left Join tblUser U3 on A.FKApproveByID=U3.PKUserID   
 Where C.ProjectCode = @ProjectCode and d.TaskName=@TaskName and d.TaskCode=@TaskCode   
 and A.TaskDate = @TaskDate  and A.FKEmpID=@EmpID'  

 SET @ParmDefinition = N'@TaskName Varchar(max),@TaskCode Varchar(max),@TaskDate Varchar(50),@ProjectCode Varchar(50),@EmpID int'  
 EXEC sp_executesql @StrQry, @ParmDefinition,@TaskName ,@TaskCode ,@TaskDate,@ProjectCode,@EmpID 
 End
    
 
  
End