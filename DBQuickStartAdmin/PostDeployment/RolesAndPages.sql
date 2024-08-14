
--*************************Role Master Data********************************

Exec uspInsertUserRoles 1,'Profile Picture','Company Settings',1,1,1,1,1,'C'
Exec uspInsertUserRoles 2,'Company Information','Company Settings',1,1,1,1,1,'C'
Exec uspInsertUserRoles 3,'Email Settings','Company Settings',1,1,1,1,1,'C'
Exec uspInsertUserRoles 4,'Payment Terms','Company Settings',1,1,1,1,1,'C'
Exec uspInsertUserRoles 5,'Billing Settings','Company Settings',1,1,1,1,1,'C'
Exec uspInsertUserRoles 6,'Invoice Template','Company Settings',1,1,1,1,1,'C'
Exec uspInsertUserRoles 7,'Invoice Email Template','Company Settings',1,1,1,1,1,'C'
Exec uspInsertUserRoles 8,'Scheduling Email Receivers','Company Settings',1,1,1,1,1,'C'
Exec uspInsertUserRoles 9,'Leave Request Email Receivers','Company Settings',1,1,1,1,1,'C'
Exec uspInsertUserRoles 10,'Attandence Machine Settings','Company Settings',1,1,1,1,1,'C'
Exec uspInsertUserRoles 11,'Announcements','Company Settings',1,1,1,1,1,'C'




Exec uspInsertUserRoles 21,'View Appointments','Appointments',1,1,1,1,1,'C'
Exec uspInsertUserRoles 22,'Schedule Availability','Appointments',1,1,1,1,1,'C'
Exec uspInsertUserRoles 23,'Schedule Availability of Others','Appointments',1,1,1,1,1,'C'
Exec uspInsertUserRoles 24,'View Appoinetments of Others','Appointments',1,1,1,1,1,'C'


Exec uspInsertUserRoles 31,'Transfer Asset','Asset Management',1,1,1,1,1,'C'
Exec uspInsertUserRoles 32,'Asset Category','Asset Management',1,1,1,1,1,'C'
Exec uspInsertUserRoles 33,'Asset Master','Asset Management',1,1,1,1,1,'C'
Exec uspInsertUserRoles 34,'Vendor Master','Asset Management',1,1,1,1,1,'C'


Exec uspInsertUserRoles 51,'File Manager','Document Management',0,1,1,1,1,'C'
Exec uspInsertUserRoles 52,'File Sharing','Document Management',0,1,1,1,1,'C'
Exec uspInsertUserRoles 53,'File Categories','Document Management',0,1,1,1,1,'C'



Exec uspInsertUserRoles 71,'Create Invoice','Billing',1,1,1,1,1,'C'
Exec uspInsertUserRoles 72,'Invoice List','Billing',1,1,1,1,1,'C'
Exec uspInsertUserRoles 73,'Receive Payment','Billing',1,1,1,1,1,'C'
Exec uspInsertUserRoles 74,'Payment Review','Billing',1,1,1,1,1,'C'
Exec uspInsertUserRoles 75,'Transaction Statements','Billing',1,1,1,1,1,'C'
--Added by Nilesh to add below two pages (Deleted and Archive InvoiceList)
Exec uspInsertUserRoles 76,'Trash Invoices','Billing',1,1,0,0,1,'C'
Exec uspInsertUserRoles 77,'Archive Invoices','Billing',1,1,0,0,1,'C' 
Exec uspInsertUserRoles 78,'Approve Invoices','Billing',1,1,1,1,1,'C'
--Exec uspInsertUserRoles 7601,'Deleted Invoices','Trash Invoices',1,1,0,0,1,'C' 

--Note coloumn value is like  -> PKRoleID, RoleName, RoleGroup, Bstatus, IsView, IsAdd, IsEdit,IsDelete, RecType
--Added by Nilesh to add below two pages (Deleted and Archive InvoiceList)

Exec uspInsertUserRoles 101,'Employee Groups','Groups',1,1,1,1,1,'C'
Exec uspInsertUserRoles 102,'Client Groups','Groups',1,1,1,1,1,'C'
Exec uspInsertUserRoles 103,'Project Groups','Groups',1,1,1,1,1,'C'
Exec uspInsertUserRoles 104,'Expense Groups','Groups',1,1,1,1,1,'C'



Exec uspInsertUserRoles 121,'Leave Request','Leave Management',1,1,1,1,1,'C'
Exec uspInsertUserRoles 122,'Approve Leave Request','Leave Management',1,1,1,1,1,'C'
Exec uspInsertUserRoles 123,'Issue Leave','Leave Management',1,1,1,1,1,'C'
Exec uspInsertUserRoles 124,'Holiday Calendar','Leave Management',1,1,1,1,1,'C'
Exec uspInsertUserRoles 125,'Leave Settings','Leave Management',1,1,1,1,1,'C'



Exec uspInsertUserRoles 161,'Project Forecasting','Project Management',1,1,1,1,1,'C'
Exec uspInsertUserRoles 162,'Project Allocation','Project Management',1,1,1,1,1,'C'
Exec uspInsertUserRoles 163,'Project Budgeting','Project Management',1,1,1,1,1,'C'
Exec uspInsertUserRoles 164,'Tax Client Setup','Project Management',0,1,1,1,1,'C'
Exec uspInsertUserRoles 165,'Tax Client Log','Project Management',0,1,1,1,1,'C'
Exec uspInsertUserRoles 166,'Tax Master File','Project Management',0,1,1,1,1,'C'


Exec uspInsertUserRoles 191,'Schedule','Schedule',1,1,1,1,1,'C'

Exec uspInsertUserRoles 201,'Enter Timesheet','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 202,'Approve Timesheet','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 203,'Employee Task Assignment','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 204,'Employee Expense Entry','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 205,'Approve Employee Expenses','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 206,'Description in Timesheet','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 207,'Bill Rate in Timesheet','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 208,'Pay Rate in Timesheet','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 209,'Memo in Timesheet','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 210,'Billable Check/Uncheck in Timesheet','Timesheet',1,1,1,1,1,'C'



Exec uspInsertUserRoles 211,'Cost Rate in Expense Entry','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 212,'Memo in Expense Entry','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 213,'Billable Check/Uncheck in Expense Entry','Timesheet',1,1,1,1,1,'C'
Exec uspInsertUserRoles 214,'Reimbursable Check/Uncheck in Expense Entry','Timesheet',1,1,1,1,1,'C'

--Exec uspInsertUserRoles 221,'Time  Clock','Time  Clock',1,1,1,1,1,'C'

Exec uspInsertUserRoles 251,'Employees','Manage',1,1,1,1,1,'C'
Exec uspInsertUserRoles 252,'Projects','Manage',1,1,1,1,1,'C'
Exec uspInsertUserRoles 253,'Clients','Manage',1,1,1,1,1,'C'
Exec uspInsertUserRoles 254,'Client Address Map','Manage',0,1,1,1,1,'C'
Exec uspInsertUserRoles 255,'Task Codes','Manage',1,1,1,1,1,'C'
Exec uspInsertUserRoles 256,'Expense Codes','Manage',1,1,1,1,1,'C'
Exec uspInsertUserRoles 257,'Departments','Manage',1,1,1,1,1,'C'
Exec uspInsertUserRoles 258,'Designations','Manage',1,1,1,1,1,'C'
Exec uspInsertUserRoles 259,'Tax Master','Manage',1,1,1,1,1,'C'
Exec uspInsertUserRoles 260,'Information Type Master','Manage',0,1,1,1,1,'C'

Exec uspInsertUserRoles 301,'Aging Report','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 302,'Analysis','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 303,'Asset Report','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 304,'Billing Report','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 305,'Budget Report','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 306,'Client Report','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 307,'Client Schedule Report','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 308,'Employee Report','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 309,'Leave Report','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 310,'Project Report','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 311,'Task Report','Reports',1,1,0,0,0,'C'
Exec uspInsertUserRoles 312,'Timesheet Report','Reports',1,1,0,0,0,'C'

--Aging Report
Exec uspInsertUserRoles 30101,'Aging Report 90 Days','Aging Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30102,'Aging Summary Report','Aging Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30103,'Aging with Client Address','Aging Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30104,'Aging Summary with Credit','Aging Report',1,1,0,0,0,'C'

--Analysis
Exec uspInsertUserRoles 30201,'A-Hours B-Hours Comparison by Employee','Analysis',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30202,'A-Hours B-Hours Comparison by Project','Analysis',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30203,'Project Analysis Report','Analysis',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30204,'Chart Report','Analysis',0,1,0,0,0,'C'

--Asset Management
Exec uspInsertUserRoles 30301,'Asset Report By Department','Asset Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30302,'Asset Report By Employee','Asset Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30303,'Asset Report By Location','Asset Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30304,'Asset Report By Condition','Asset Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30305,'Asset Report By Category','Asset Report',1,1,0,0,0,'C'


Exec uspInsertUserRoles 30401,'Approved Time and Expenses with Memos','Billing Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30402,'Invoice Register','Billing Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30403,'Invoice Register with Costs','Billing Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30404,'Billing Statement by Client','Billing Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30405,'Billing Statement by Project','Billing Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30406,'Percentage Billed','Billing Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30407,'Employee Default Bill Rates','Billing Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30408,'Billed Time and Expenses Detail by Project & Employee with Cost','Billing Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30409,'Un-Billed Time and Expenses Detail by Project & Employee with Cost','Billing Report',1,1,0,0,0,'C'


Exec uspInsertUserRoles 30501,'Budget Summary Report','Budget Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30502,'Budget Detail by Project & Employee','Budget Report',1,1,0,0,0,'C'

Exec uspInsertUserRoles 30601,'Client Master File (List)','Client Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30602,'Client Master File (Details)','Client Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30603,'Expenses by Client','Client Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30604,'Expenses by Item','Client Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30605,'Invoice Register by Client','Client Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30606,'Monthly Billing Summary by Client','Client Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30607,'Time & Expenses Detail by Client & Project','Client Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30608,'Time & Expense by Client, Project and Employee','Client Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30609,'Time & Expenses Summary by Client','Client Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30610,'Client, Employee and Time Metrix','Client Report',0,1,0,0,0,'C'
Exec uspInsertUserRoles 30611,'Employee, Client and Time Metrix','Client Report',0,1,0,0,0,'C'


Exec uspInsertUserRoles 30701,'Schedule Report by Client','Client Schedule Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30702,'Schedule Report by Employee & Client','Client Schedule Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30703,'Schedule Summary Report','Client Schedule Report',0,1,0,0,0,'C'

Exec uspInsertUserRoles 30801,'Performance Report','Employee Report',0,1,0,0,0,'C'
Exec uspInsertUserRoles 30802,'Employee Expenses by Item','Employee Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30803,'Employee Expenses Report','Employee Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 30804,'Cumulative Report','Employee Report',0,1,0,0,0,'C'

--Leave Report
Exec uspInsertUserRoles 30901,'Employee Leave Register','Leave Report',0,1,0,0,0,'C'
Exec uspInsertUserRoles 30902,'Employee Leave Summary','Leave Report',0,1,0,0,0,'C'

--Project Report
Exec uspInsertUserRoles 31001,'Project Master','Project Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31002,'Project Forecasting Report','Project Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31003,'Project Allocation Report','Project Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31004,'Project Breakdown Summary','Project Report',0,1,0,0,0,'C'

--Task Report
Exec uspInsertUserRoles 31101,'Budgeted Task Report','Task Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31102,'Assigned Task Report','Task Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31103,'Task Master File','Task Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31104,'Expenses Code Master File','Task Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31105,'Analysis by Project, Employee & Task','Task Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31106,'Analysis by Project, Task & Employee','Task Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31107,'Analysis by Employee & Task','Task Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31108,'Grouped Activity Code Master File','Task Report',0,1,0,0,0,'C'
Exec uspInsertUserRoles 31109,'Task Summary','Task Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31110,'Expenses Summary','Task Report',1,1,0,0,0,'C'

Exec uspInsertUserRoles 31201,'Employee Timesheet','Timesheet Report',1,1,0,0,0,'C'
Exec uspInsertUserRoles 31202,'Time Summary by Employee','Timesheet Report',1,1,0,0,0,'C'

---
--- Define Remaining Roles Like Above 
---




--*************************************Page Master**************************************************
Exec uspInsertPage 100,1,0,'Dashboard','Dashboard.aspx','','<i class="uil-home-alt"></i>',1,1,'C'


Exec uspInsertPage 1000,2,0,'Company Settings','','','<i class="fa fa-cog"></i>',1,1,'C'
Exec uspInsertPage 1001,1,1000,'Profile Picture','ProfilePicture.aspx','','',1,1,'C'
Exec uspInsertPage 1002,2,1000,'Company Information','CompanyInformation.aspx','','',1,1,'C'
Exec uspInsertPage 1003,3,1000,'Email Settings','EmailSettings.aspx','','',1,1,'C'
Exec uspInsertPage 1004,4,1000,'Payment Terms','PaymentTerms.aspx','','',1,1,'C'
Exec uspInsertPage 1005,5,1000,'Billing Settings','BillingSettings.aspx','','',1,1,'C'
Exec uspInsertPage 1006,6,1000,'Invoice Template','InvoiceTemplate.aspx','','',1,1,'C'
Exec uspInsertPage 1007,7,1000,'Invoice Email Template','InvoiceEmailTemplate.aspx','','',1,1,'C'
Exec uspInsertPage 1008,8,1000,'Scheduling Email Receivers','SchedulingEmailReceivers.aspx','','',1,1,'C'
Exec uspInsertPage 1009,9,1000,'Leave Request Email Receivers','LeaveRequestEmailReceivers.aspx','','',1,1,'C'
Exec uspInsertPage 1010,10,1000,'Attandence Machine Settings','AttandenceMachineSettings.aspx','','',1,1,'C'
Exec uspInsertPage 1011,11,1000,'Announcements','Announcements.aspx','','',1,1,'C'

Exec uspInsertPage 1020,3,0,'Appointments','','','<i class="uil-briefcase "></i>',1,0,'C'
Exec uspInsertPage 1021,1,1020,'View Appointments','ViewAppointments.aspx','','',1,1,'C'
Exec uspInsertPage 1022,2,1020,'Schedule Availability','ScheduleAvailability.aspx','','',1,1,'C'

Exec uspInsertPage 1030,4,0,'Asset Management','','',' <i class="uil-building "></i>',1,0,'C'
Exec uspInsertPage 1031,1,1030,'Transfer Asset','TransferAsset.aspx','','',1,1,'C'
Exec uspInsertPage 1032,2,1030,'Asset Category','ItemCategory.aspx','','',1,1,'C'
Exec uspInsertPage 1033,3,1030,'Asset Master','AssetMaster.aspx','','',1,1,'C'
Exec uspInsertPage 1034,4,1030,'Vendor Master','VendorMaster.aspx','','',1,1,'C'



Exec uspInsertPage 1050,5,0,'Document Management','','','<i class="uil-file"></i>',0,0,'C'
Exec uspInsertPage 1051,1,1050,'File Manager','FileManager.aspx','','',0,1,'C'
Exec uspInsertPage 1052,2,1050,'File Sharing','FileSharing.aspx','','',0,1,'C'
Exec uspInsertPage 1053,3,1050,'File Categories','FileCategories.aspx','','',0,1,'C'

Exec uspInsertPage 1070,5,0,'Billing','','','<i class="uil-invoice"></i>',1,0,'C'
Exec uspInsertPage 1071,1,1070,'Create Invoice','CreateInvoice.aspx','','',1,1,'C'
Exec uspInsertPage 1072,4,1070,'Invoice List','InvoiceList.aspx','','',1,1,'C'
Exec uspInsertPage 1073,5,1070,'Receive Payment','ReceivePayment.aspx','','',1,1,'C'
Exec uspInsertPage 1074,6,1070,'Payment Review','PaymentReview.aspx','','',1,1,'C'
Exec uspInsertPage 1075,7,1070,'Transaction Statements','TransactionStatements.aspx','','',1,1,'C'
--Added by Nilesh to add below two pages (Deleted and Archive InvoiceList)
Exec uspInsertPage 1076,8,1070,'Trash Invoices','InvoiceListDeleted.aspx','','',1,1,'C'
Exec uspInsertPage 1077,9,1070,'Archive Invoices','InvoiceListArchive.aspx','','',1,1,'C'
--Added by Nilesh to add below two pages (Deleted and Archive InvoiceList)

Exec uspInsertPage 1100,6,0,'Groups','','',' <i class="uil-layer-group "></i>',1,0,'C'
Exec uspInsertPage 1101,1,1100,'Employee Groups','EmployeeGroups.aspx','','',1,1,'C'
Exec uspInsertPage 1102,2,1100,'Client Groups','ClientGroups.aspx','','',1,1,'C'
Exec uspInsertPage 1103,3,1100,'Project Groups','ProjectGroups.aspx','','',1,1,'C'
Exec uspInsertPage 1104,4,1100,'Expense Groups','ExpenseGroups.aspx','','',1,1,'C'

Exec uspInsertPage 1120,7,0,'Leave Management','','','<i class="uil-cell"></i>',1,0,'C'
Exec uspInsertPage 1121,1,1120,'Approve Leave Request','ApproveLeaveRequest.aspx','','',1,1,'C'
Exec uspInsertPage 1122,1,1120,'Leave Request','LeaveRequest.aspx','','',1,1,'C'
Exec uspInsertPage 1123,2,1120,'Issue Leave','IssueLeave.aspx','','',1,1,'C'
Exec uspInsertPage 1124,3,1120,'Holiday Calendar','HolidayCalendar.aspx','','',1,1,'C'
Exec uspInsertPage 1125,4,1120,'Leave Settings','LeaveSettings.aspx','','',1,1,'C'




Exec uspInsertPage 1160,8,0,'Project Management','','','<i class="uil-sitemap"></i>',1,0,'C'
Exec uspInsertPage 1161,1,1160,'Project Forecasting','ProjectForecasting.aspx','','',1,1,'C'
Exec uspInsertPage 1162,2,1160,'Project Allocation','ProjectAllocation.aspx','','',1,1,'C'
Exec uspInsertPage 1163,3,1160,'Project Budgeting','ProjectBudgeting.aspx','','',1,1,'C'
Exec uspInsertPage 1164,4,1160,'Tax Client Setup','TaxClientSetup.aspx','','',0,1,'C'
Exec uspInsertPage 1165,5,1160,'Tax Client Log','TaxClientLog.aspx','','',0,1,'C'
Exec uspInsertPage 1166,6,1160,'Tax Master File','TaxMasterFile.aspx','','',0,1,'C'

Exec uspInsertPage 1191,9,0,'Schedule','Schedule.aspx','','<i class="uil-calender"></i>',1,1,'C'

Exec uspInsertPage 1200,10,0,'Timesheet','#','','<i class="uil-clock-three"></i>',1,0,'C'
Exec uspInsertPage 1201,1,1200,'Enter Timesheet','EnterTimeSheet.aspx','','',1,1,'C'
Exec uspInsertPage 1203,2,1200,'Employee Task Assignment','EmployeeTaskAssignment.aspx','','',1,1,'C'
Exec uspInsertPage 1204,3,1200,'Employee Expense Entry','EmployeeExpenseEntry.aspx','','',1,1,'C'



Exec uspInsertPage 1250,10,0,'Manage','#','','<i class="uil-book-alt"></i>',1,0,'C'
Exec uspInsertPage 1251,1,1250,'Employees','Employees.aspx','','',1,1,'C'
Exec uspInsertPage 1252,2,1250,'Projects','Projects.aspx','','',1,1,'C'
Exec uspInsertPage 1253,3,1250,'Clients','Clients.aspx','','',1,1,'C'
Exec uspInsertPage 1254,4,1250,'Client Address Map','ClientAddressMap.aspx','','',0,1,'C'
Exec uspInsertPage 1255,5,1250,'Task Codes','TaskCodes.aspx','','',1,1,'C'
Exec uspInsertPage 1256,6,1250,'Expense Codes','ExpenseCodes.aspx','','',1,1,'C'
Exec uspInsertPage 1257,7,1250,'Departments','Departments.aspx','','',1,1,'C'
Exec uspInsertPage 1258,8,1250,'Designations','Designations.aspx','','',1,1,'C'
Exec uspInsertPage 1259,9,1250,'Tax Master','TaxMaster.aspx','','',1,1,'C'
Exec uspInsertPage 1260,10,1250,'Information Type Master','InformationTypeMaster.aspx','','',0,1,'C'

Exec uspInsertPage 1300,12,0,'Reports','','','<i class="uil-list-ul"></i>',1,0,'C'
Exec uspInsertPage 1301,1,1300,'Aging Report','#','','',1,1,'C'
Exec uspInsertPage 1302,2,1300,'Analysis','#','','',1,1,'C'
Exec uspInsertPage 1303,3,1300,'Asset Report','#','','',1,1,'C'
Exec uspInsertPage 1304,4,1300,'Billing Report','#','','',1,1,'C'
Exec uspInsertPage 1305,5,1300,'Budget Report','#','','',1,1,'C'
Exec uspInsertPage 1306,6,1300,'Client Report','#','','',1,1,'C'
Exec uspInsertPage 1307,7,1300,'Client Schedule Report','#','','',1,1,'C'
Exec uspInsertPage 1308,8,1300,'Employee Report','#','','',1,1,'C'
Exec uspInsertPage 1309,9,1300,'Leave Report','#','','',0,1,'C'
Exec uspInsertPage 1310,10,1300,'Project Report','#','','',1,1,'C'
Exec uspInsertPage 1311,11,1300,'Task Report','#','','',1,1,'C'
Exec uspInsertPage 1312,12,1300,'Timesheet Report','#','','',1,1,'C'

Exec uspInsertPage 130101,1,1301,'Aging Report 90 Days','RptAgingReport90Days.aspx','','',1,1,'C'
Exec uspInsertPage 130102,2,1301,'Aging Summary Report','RptAgingSummaryReport.aspx','','',1,1,'C'
Exec uspInsertPage 130103,3,1301,'Aging with Client Address','RptAgingwithClientAddress.aspx','','',1,1,'C'
Exec uspInsertPage 130104,4,1301,'Aging Summary with Credit','RptAgingSummarywithCredit.aspx','','',1,1,'C'



Exec uspInsertPage 130201,1,1302,'A-Hours B-Hours Comparison by Employee','RptAHoursBHoursComparisonbyEmployee.aspx','','',1,1,'C'
Exec uspInsertPage 130202,2,1302,'A-Hours B-Hours Comparison by Project','RptAHoursBHoursComparisonbyProject.aspx','','',1,1,'C'
Exec uspInsertPage 130203,3,1302,'Project Analysis Report','RptProjectAnalysisReport.aspx','','',1,1,'C'
Exec uspInsertPage 130204,4,1302,'Chart Report','RptChartReport.aspx','','',0,1,'C'


Exec uspInsertPage 130301,1,1303,'Asset Report By Department','RptAssetReportByDepartment.aspx','','',1,1,'C'
Exec uspInsertPage 130302,2,1303,'Asset Report By Employee','RptAssetReportByEmployee.aspx','','',1,1,'C'
Exec uspInsertPage 130303,3,1303,'Asset Report By Location','RptAssetReportByLocation.aspx','','',1,1,'C'
Exec uspInsertPage 130304,4,1303,'Asset Report By Condition','RptAssetReportByCondition.aspx','','',1,1,'C'
Exec uspInsertPage 130305,5,1303,'Asset Report By Category','RptAssetReportByCategory.aspx','','',1,1,'C'


Exec uspInsertPage 130401,1,1304,'Approved Time and Expenses with Memos','RptApprovedTimeandExpenseswithMemos.aspx','','',1,1,'C'
Exec uspInsertPage 130402,2,1304,'Invoice Register','RptInvoiceRegister.aspx','','',1,1,'C'
Exec uspInsertPage 130403,3,1304,'Invoice Register with Costs','RptInvoiceRegisterwithCosts.aspx','','',1,1,'C'
Exec uspInsertPage 130404,4,1304,'Billing Statement by Client','RptBillingStatementbyClient.aspx','','',1,1,'C'
Exec uspInsertPage 130405,5,1304,'Billing Statement by Project','RptBillingStatementbyProject.aspx','','',1,1,'C'
Exec uspInsertPage 130406,6,1304,'Percentage Billed','RptPercentageBilled.aspx','','',1,1,'C'
Exec uspInsertPage 130407,7,1304,'Employee Default Bill Rates','RptEmployeeDefaultBillRates.aspx','','',1,1,'C'
Exec uspInsertPage 130408,8,1304,'Billed Time and Expenses Detail by Project & Employee','RptBilledTimeandExpensesDetailbyProjectEmplo.aspx','','',1,1,'C'
Exec uspInsertPage 130409,9,1304,'Un-Billed Time and Expenses Detail by Project & Employee','RptUnBilledTimeandExpensesDetailbyProjectEm.aspx','','',1,1,'C'


Exec uspInsertPage 130501,1,1305,'Budget Summary Report','RptBudgetSummaryReport.aspx','','',1,1,'C'
Exec uspInsertPage 130502,2,1305,'Budget Detail by Project & Employee','RptBudgetDetailbyProjectEmployee.aspx','','',1,1,'C'


Exec uspInsertPage 130601,1,1306,'Client Master File (List)','RptClientMasterFileList.aspx','','',1,1,'C'
Exec uspInsertPage 130602,2,1306,'Client Master File (Details)','RptClientMasterFileDetails.aspx','','',1,1,'C'
Exec uspInsertPage 130603,3,1306,'Expenses by Client','RptExpensesbyClient.aspx','','',1,1,'C'
Exec uspInsertPage 130604,4,1306,'Expenses by Item','RptExpensesbyItem.aspx','','',1,1,'C'
Exec uspInsertPage 130605,5,1306,'Invoice Register by Client','RptInvoiceRegisterbyClient.aspx','','',1,1,'C'
Exec uspInsertPage 130606,6,1306,'Monthly Billing Summary by Client','RptMonthlyBillingSummarybyClient.aspx','','',1,1,'C'
Exec uspInsertPage 130607,7,1306,'Time & Expenses Detail by Client & Project','RptTimeExpensesDetailbyClientProject.aspx','','',1,1,'C'
Exec uspInsertPage 130608,8,1306,'Time & Expense by Client, Project and Employee','RptTimeExpensebyClientProjectandEmployee.aspx','','',1,1,'C'
Exec uspInsertPage 130609,9,1306,'Time & Expenses Summary by Client','RptTimeExpensesSummarybyClient.aspx','','',1,1,'C'
Exec uspInsertPage 130610,10,1306,'Client, Employee and Time Metrix','RptClientEmployeeandTimeMetrix.aspx','','',0,1,'C'
Exec uspInsertPage 130611,11,1306,'Employee, Client and Time Metrix','RptEmployeeClientandTimeMetrix.aspx','','',0,1,'C'


Exec uspInsertPage 130701,1,1307,'Schedule Report by Client','RptScheduleReportbyClient.aspx','','',1,1,'C'
Exec uspInsertPage 130702,2,1307,'Schedule Report by Employee & Client','RptScheduleReportbyEmployeeClient.aspx','','',1,1,'C'
Exec uspInsertPage 130703,3,1307,'Schedule Summary Report','RptScheduleSummaryReport.aspx','','',0,1,'C'


Exec uspInsertPage 130801,1,1308,'Performance Report','RptPerformanceReport.aspx','','',0,1,'C'
Exec uspInsertPage 130802,2,1308,'Employee Expenses by Item','RptEmployeeExpensesbyItem.aspx','','',1,1,'C'
Exec uspInsertPage 130803,3,1308,'Employee Expenses Report','RptEmployeeExpensesReport.aspx','','',1,1,'C'
Exec uspInsertPage 130804,4,1308,'Cumulative Report','RptCumulativeReport.aspx','','',0,1,'C'


Exec uspInsertPage 130901,1,1309,'Employee Leave Register','RptEmployeeLeaveRegister.aspx','','',0,1,'C'
Exec uspInsertPage 130902,2,1309,'Employee Leave Summary','RptEmployeeLeaveSummary.aspx','','',0,1,'C'


Exec uspInsertPage 131001,1,1310,'Project Master','RptProjectMaster.aspx','','',1,1,'C'
Exec uspInsertPage 131002,2,1310,'Project Forecasting Report','RptProjectForecastingReport.aspx','','',1,1,'C'
Exec uspInsertPage 131003,3,1310,'Project Allocation Report','RptProjectAllocationReport.aspx','','',1,1,'C'
Exec uspInsertPage 131004,4,1310,'Project Breakdown Summary','RptProjectBreakdownSummary.aspx','','',0,1,'C'


Exec uspInsertPage 131101,1,1311,'Budgeted Task Report','RptBudgetedTaskReport.aspx','','',1,1,'C'
Exec uspInsertPage 131102,2,1311,'Assigned Task Report','RptAssignedTaskReport.aspx','','',1,1,'C'
Exec uspInsertPage 131103,3,1311,'Task Master File','RptTaskMasterFile.aspx','','',1,1,'C'
Exec uspInsertPage 131104,4,1311,'Expenses Code Master File','RptExpensesCodeMasterFile.aspx','','',1,1,'C'
Exec uspInsertPage 131105,5,1311,'Analysis by Project, Employee & Task','RptAnalysisbyProjectEmployeeTask.aspx','','',1,1,'C'
Exec uspInsertPage 131106,6,1311,'Analysis by Project, Task & Employee','RptAnalysisbyProjectTaskEmployee.aspx','','',1,1,'C'
Exec uspInsertPage 131107,7,1311,'Analysis by Employee & Task','RptAnalysisbyEmployeeTask.aspx','','',1,1,'C'
Exec uspInsertPage 131108,8,1311,'Grouped Activity Code Master File','RptGroupedActivityCodeMasterFile.aspx','','',0,1,'C'
Exec uspInsertPage 131109,9,1311,'Task Summary','RptTaskSummary.aspx','','',1,1,'C'
Exec uspInsertPage 131110,10,1311,'Expenses Summary','RptExpensesSummary.aspx','','',1,1,'C'


Exec uspInsertPage 131201,1,1312,'Employee Timesheet','RptEmployeeTimesheet.aspx','','',1,1,'C'
Exec uspInsertPage 131202,2,1312,'Time Summary by Employee','RptTimeSummarybyEmployee.aspx','','',1,1,'C'

----
---Define remaining pages as above 
----


---Dashboard Links
Delete From tblDashboardLink
Insert Into tblDashboardLink values(1,1,'Timesheet','Enter, Approve, Reject','<i class="uil-clock-three"></i>',1201)
Insert Into tblDashboardLink values(2,2,'Expenses','Enter, Approve, Reimburse','<i class="uil-enter"></i>',1204)
Insert Into tblDashboardLink values(3,3,'Employee','Add, Modify, Role Settings',' <i class="uil-user-circle"></i>',1251)
Insert Into tblDashboardLink values(4,4,'Billing','Invoice, Payments, Transactions',' <i class="uil-exchange"></i>',1070)
Insert Into tblDashboardLink values(5,5,'Appointments','Manage Appointments, Schedule Availability','<i class="uil-briefcase "></i>',1020)
Insert Into tblDashboardLink values(6,6,'Asset Management','Manage, Transfer, Location Assets','<i class="uil-building "></i>',1030)
Insert Into tblDashboardLink values(7,7,'Project Management','Forecasting, Allocation, Budgeting','<i class="uil-sitemap"></i>',1160)
Insert Into tblDashboardLink values(8,8,'Schedule','Client Schedule, Assign, Email','<i class="uil-calender"></i>',1191)
Insert Into tblDashboardLink values(9,9,'Document Management','File Manager, Sharing, Handing','<i class="uil-file"></i>',1050)



--***********************************Link Page And Role***************************************************************
Truncate table  tblPageRoleLnk

--Dashboard
Insert into tblPageRoleLnk values(100,null)

--Compnay Settings
--If Any Roles Found Related to Company The Parent Menu of Company Setting will be shown 
Insert into tblPageRoleLnk values(1000,1)
Insert into tblPageRoleLnk values(1000,2)
Insert into tblPageRoleLnk values(1000,3)
Insert into tblPageRoleLnk values(1000,4)
Insert into tblPageRoleLnk values(1000,5)
Insert into tblPageRoleLnk values(1000,6)
Insert into tblPageRoleLnk values(1000,7)
Insert into tblPageRoleLnk values(1000,8)
Insert into tblPageRoleLnk values(1000,9)
Insert into tblPageRoleLnk values(1000,10)
Insert into tblPageRoleLnk values(1000,11)

Insert into tblPageRoleLnk values(1001,1)
Insert into tblPageRoleLnk values(1002,2)
Insert into tblPageRoleLnk values(1003,3)
Insert into tblPageRoleLnk values(1004,4)
Insert into tblPageRoleLnk values(1005,5)
Insert into tblPageRoleLnk values(1006,6)
Insert into tblPageRoleLnk values(1007,7)
Insert into tblPageRoleLnk values(1008,8)
Insert into tblPageRoleLnk values(1009,9)
Insert into tblPageRoleLnk values(1010,10)
Insert into tblPageRoleLnk values(1010,11)

--Appointments
Insert into tblPageRoleLnk values(1020,21)
Insert into tblPageRoleLnk values(1020,22)
Insert into tblPageRoleLnk values(1021,21)
Insert into tblPageRoleLnk values(1022,22)

--Asset Management
Insert into tblPageRoleLnk values(1030,31)
Insert into tblPageRoleLnk values(1030,32)
Insert into tblPageRoleLnk values(1030,33)
Insert into tblPageRoleLnk values(1031,31)
Insert into tblPageRoleLnk values(1032,32)
Insert into tblPageRoleLnk values(1033,33)

--Document Management
Insert into tblPageRoleLnk values(1050,51)
Insert into tblPageRoleLnk values(1050,52)
Insert into tblPageRoleLnk values(1050,53)
Insert into tblPageRoleLnk values(1051,51)
Insert into tblPageRoleLnk values(1052,52)
Insert into tblPageRoleLnk values(1053,53)

--Billing
Insert into tblPageRoleLnk values(1070,71)
Insert into tblPageRoleLnk values(1070,72)
Insert into tblPageRoleLnk values(1070,73)
Insert into tblPageRoleLnk values(1070,74)
Insert into tblPageRoleLnk values(1070,75)
Insert into tblPageRoleLnk values(1071,71)
Insert into tblPageRoleLnk values(1072,72)
Insert into tblPageRoleLnk values(1073,73)
Insert into tblPageRoleLnk values(1074,74)
Insert into tblPageRoleLnk values(1075,75)
--Added By Nilesh to link new created pages (Trash Invoices)
Insert into tblPageRoleLnk values(1076,76)
Insert into tblPageRoleLnk values(1077,77)
--Added By Nilesh to link new created pages (Trash Invoices)


--Groups
Insert into tblPageRoleLnk values(1100,101)
Insert into tblPageRoleLnk values(1100,102)
Insert into tblPageRoleLnk values(1100,103)
Insert into tblPageRoleLnk values(1100,104)
Insert into tblPageRoleLnk values(1101,101)
Insert into tblPageRoleLnk values(1102,102)
Insert into tblPageRoleLnk values(1103,103)
Insert into tblPageRoleLnk values(1104,104)

--Leave Management
Insert into tblPageRoleLnk values(1120,121)
Insert into tblPageRoleLnk values(1120,122)
Insert into tblPageRoleLnk values(1120,123)
Insert into tblPageRoleLnk values(1120,124)
Insert into tblPageRoleLnk values(1120,125)
Insert into tblPageRoleLnk values(1121,121)
Insert into tblPageRoleLnk values(1122,122)
Insert into tblPageRoleLnk values(1123,123)
Insert into tblPageRoleLnk values(1124,124)
Insert into tblPageRoleLnk values(1125,125)

--Project Management
Insert into tblPageRoleLnk values(1160,161)
Insert into tblPageRoleLnk values(1160,162)
Insert into tblPageRoleLnk values(1160,163)
Insert into tblPageRoleLnk values(1160,164)
Insert into tblPageRoleLnk values(1160,165)
Insert into tblPageRoleLnk values(1160,166)
Insert into tblPageRoleLnk values(1161,161)
Insert into tblPageRoleLnk values(1162,162)
Insert into tblPageRoleLnk values(1163,163)
Insert into tblPageRoleLnk values(1164,164)
Insert into tblPageRoleLnk values(1165,165)
Insert into tblPageRoleLnk values(1166,166)

Insert into tblPageRoleLnk values(1191,191)

--Timesheet
Insert into tblPageRoleLnk values(1200,201)
Insert into tblPageRoleLnk values(1200,203)
Insert into tblPageRoleLnk values(1200,204)
Insert into tblPageRoleLnk values(1201,201)
Insert into tblPageRoleLnk values(1203,203)
Insert into tblPageRoleLnk values(1204,204)


--Manage
Insert into tblPageRoleLnk values(1250,251)
Insert into tblPageRoleLnk values(1250,252)
Insert into tblPageRoleLnk values(1250,253)
Insert into tblPageRoleLnk values(1250,254)
Insert into tblPageRoleLnk values(1250,255)
Insert into tblPageRoleLnk values(1250,256)
Insert into tblPageRoleLnk values(1250,257)
Insert into tblPageRoleLnk values(1250,258)
Insert into tblPageRoleLnk values(1250,259)
Insert into tblPageRoleLnk values(1250,260)

Insert into tblPageRoleLnk values(1251,251)
Insert into tblPageRoleLnk values(1252,252)
Insert into tblPageRoleLnk values(1253,253)
Insert into tblPageRoleLnk values(1254,254)
Insert into tblPageRoleLnk values(1255,255)
Insert into tblPageRoleLnk values(1256,256)
Insert into tblPageRoleLnk values(1257,257)
Insert into tblPageRoleLnk values(1258,258)
Insert into tblPageRoleLnk values(1259,259)
Insert into tblPageRoleLnk values(1260,260)


--Reports
Insert into tblPageRoleLnk values(1300,301)
Insert into tblPageRoleLnk values(1300,302)
Insert into tblPageRoleLnk values(1300,303)
Insert into tblPageRoleLnk values(1300,304)
Insert into tblPageRoleLnk values(1300,305)
Insert into tblPageRoleLnk values(1300,306)
Insert into tblPageRoleLnk values(1300,307)
Insert into tblPageRoleLnk values(1300,308)
Insert into tblPageRoleLnk values(1300,309)
Insert into tblPageRoleLnk values(1300,310)
Insert into tblPageRoleLnk values(1300,311)
Insert into tblPageRoleLnk values(1300,312)

Insert into tblPageRoleLnk values(1301,301)
Insert into tblPageRoleLnk values(1302,302)
Insert into tblPageRoleLnk values(1303,303)
Insert into tblPageRoleLnk values(1304,304)
Insert into tblPageRoleLnk values(1305,305)
Insert into tblPageRoleLnk values(1306,306)
Insert into tblPageRoleLnk values(1307,307)
Insert into tblPageRoleLnk values(1308,308)
Insert into tblPageRoleLnk values(1309,309)
Insert into tblPageRoleLnk values(1310,310)
Insert into tblPageRoleLnk values(1311,311)
Insert into tblPageRoleLnk values(1312,312)

--Aging Report
Insert into tblPageRoleLnk values(1301,30101)
Insert into tblPageRoleLnk values(1301,30102)
Insert into tblPageRoleLnk values(1301,30103)
Insert into tblPageRoleLnk values(1301,30104)
Insert into tblPageRoleLnk values(130101,30101)
Insert into tblPageRoleLnk values(130102,30102)
Insert into tblPageRoleLnk values(130103,30103)
Insert into tblPageRoleLnk values(130104,30104)

--Analysis
Insert into tblPageRoleLnk values(1302,30201)
Insert into tblPageRoleLnk values(1302,30202)
Insert into tblPageRoleLnk values(1302,30203)
Insert into tblPageRoleLnk values(1302,30204)
Insert into tblPageRoleLnk values(130201,30201)
Insert into tblPageRoleLnk values(130202,30202)
Insert into tblPageRoleLnk values(130203,30203)
Insert into tblPageRoleLnk values(130204,30204)

--Asset Report
Insert into tblPageRoleLnk values(1303,30301)
Insert into tblPageRoleLnk values(1303,30302)
Insert into tblPageRoleLnk values(1303,30303)
Insert into tblPageRoleLnk values(1303,30304)
Insert into tblPageRoleLnk values(1303,30305)
Insert into tblPageRoleLnk values(130301,30301)
Insert into tblPageRoleLnk values(130302,30302)
Insert into tblPageRoleLnk values(130303,30303)
Insert into tblPageRoleLnk values(130304,30304)
Insert into tblPageRoleLnk values(130305,30305)

--Billing Report
Insert into tblPageRoleLnk values(1304,30401)
Insert into tblPageRoleLnk values(1304,30402)
Insert into tblPageRoleLnk values(1304,30403)
Insert into tblPageRoleLnk values(1304,30404)
Insert into tblPageRoleLnk values(1304,30405)
Insert into tblPageRoleLnk values(1304,30406)
Insert into tblPageRoleLnk values(1304,30407)
Insert into tblPageRoleLnk values(1304,30408)
Insert into tblPageRoleLnk values(1304,30409)
Insert into tblPageRoleLnk values(130401,30401)
Insert into tblPageRoleLnk values(130402,30402)
Insert into tblPageRoleLnk values(130403,30403)
Insert into tblPageRoleLnk values(130404,30404)
Insert into tblPageRoleLnk values(130405,30405)
Insert into tblPageRoleLnk values(130406,30406)
Insert into tblPageRoleLnk values(130407,30407)
Insert into tblPageRoleLnk values(130408,30408)
Insert into tblPageRoleLnk values(130409,30409)

--Budget Report
Insert into tblPageRoleLnk values(1305,30501)
Insert into tblPageRoleLnk values(1305,30502)
Insert into tblPageRoleLnk values(130501,30501)
Insert into tblPageRoleLnk values(130502,30502)

--Client Report
Insert into tblPageRoleLnk values(1306,30601)
Insert into tblPageRoleLnk values(1306,30602)
Insert into tblPageRoleLnk values(1306,30603)
Insert into tblPageRoleLnk values(1306,30604)
Insert into tblPageRoleLnk values(1306,30605)
Insert into tblPageRoleLnk values(1306,30606)
Insert into tblPageRoleLnk values(1306,30607)
Insert into tblPageRoleLnk values(1306,30608)
Insert into tblPageRoleLnk values(1306,30609)
Insert into tblPageRoleLnk values(1306,30610)
Insert into tblPageRoleLnk values(1306,30611)
Insert into tblPageRoleLnk values(130601,30601)
Insert into tblPageRoleLnk values(130602,30602)
Insert into tblPageRoleLnk values(130603,30603)
Insert into tblPageRoleLnk values(130604,30604)
Insert into tblPageRoleLnk values(130605,30605)
Insert into tblPageRoleLnk values(130606,30606)
Insert into tblPageRoleLnk values(130607,30607)
Insert into tblPageRoleLnk values(130608,30608)
Insert into tblPageRoleLnk values(130609,30609)
Insert into tblPageRoleLnk values(130610,30610)
Insert into tblPageRoleLnk values(130611,30611)

--Client Schedule Report
Insert into tblPageRoleLnk values(1307,30701)
Insert into tblPageRoleLnk values(1307,30702)
Insert into tblPageRoleLnk values(1307,30703)
Insert into tblPageRoleLnk values(130701,30701)
Insert into tblPageRoleLnk values(130702,30702)
Insert into tblPageRoleLnk values(130703,30703)

--Employee Report
Insert into tblPageRoleLnk values(1308,30801)
Insert into tblPageRoleLnk values(1308,30802)
Insert into tblPageRoleLnk values(1308,30803)
Insert into tblPageRoleLnk values(1308,30804)
Insert into tblPageRoleLnk values(130801,30801)
Insert into tblPageRoleLnk values(130802,30802)
Insert into tblPageRoleLnk values(130803,30803)
Insert into tblPageRoleLnk values(130804,30804)

--Leave Report
Insert into tblPageRoleLnk values(1309,30901)
Insert into tblPageRoleLnk values(1309,30902)
Insert into tblPageRoleLnk values(130901,30901)
Insert into tblPageRoleLnk values(130902,30902)

--Project Report
Insert into tblPageRoleLnk values(1310,31001)
Insert into tblPageRoleLnk values(1310,31002)
Insert into tblPageRoleLnk values(1310,31003)
Insert into tblPageRoleLnk values(1310,31004)
Insert into tblPageRoleLnk values(131001,31001)
Insert into tblPageRoleLnk values(131002,31002)
Insert into tblPageRoleLnk values(131003,31003)
Insert into tblPageRoleLnk values(131004,31004)

--Task Report
Insert into tblPageRoleLnk values(1311,31101)
Insert into tblPageRoleLnk values(1311,31102)
Insert into tblPageRoleLnk values(1311,31103)
Insert into tblPageRoleLnk values(1311,31104)
Insert into tblPageRoleLnk values(1311,31105)
Insert into tblPageRoleLnk values(1311,31106)
Insert into tblPageRoleLnk values(1311,31107)
Insert into tblPageRoleLnk values(1311,31108)
Insert into tblPageRoleLnk values(1311,31109)
Insert into tblPageRoleLnk values(1311,31110)
Insert into tblPageRoleLnk values(131101,31101)
Insert into tblPageRoleLnk values(131102,31102)
Insert into tblPageRoleLnk values(131103,31103)
Insert into tblPageRoleLnk values(131104,31104)
Insert into tblPageRoleLnk values(131105,31105)
Insert into tblPageRoleLnk values(131106,31106)
Insert into tblPageRoleLnk values(131107,31107)
Insert into tblPageRoleLnk values(131108,31108)
Insert into tblPageRoleLnk values(131109,31109)
Insert into tblPageRoleLnk values(131110,31110)

--Timesheet Report
Insert into tblPageRoleLnk values(1312,31201)
Insert into tblPageRoleLnk values(1312,31202)
Insert into tblPageRoleLnk values(131201,31201)
Insert into tblPageRoleLnk values(131202,31202)