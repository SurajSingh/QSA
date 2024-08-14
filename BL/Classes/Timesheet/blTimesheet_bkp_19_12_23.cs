using System;
using System.Data;

namespace BL.Timesheet
{
    public class blTimesheet : DAL.clsDAL
    {
        //Added By Nilesh - Start
        public DataSet GetTimesheet(string ProjectCode, string TaskCode, string TaskName, string TaskDate,int EmpID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTimesheetEntry", TaskName, TaskCode, DateTimeOffset.Parse(TaskDate).ToString("yyyyMMdd"), ProjectCode, EmpID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetClientCodes()
        {
            dbcommand = db.GetStoredProcCommand("uspGetClientCodes");
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetTaskCodes()
        {
            dbcommand = db.GetStoredProcCommand("uspGetTaskCodes");
            return db.ExecuteDataSet(dbcommand);
        }

        public void UpdateTimesheetEntryHours(int PKID, float Hours)
        {
            dbcommand = db.GetStoredProcCommand("uspUpdateTimesheetHours", PKID, Hours);
            db.ExecuteNonQuery(dbcommand);
            return;
        }
        //Added by Nilesh - End

        public DataSet GetTimesheet(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKEmpID, string FKClientID, string FKProjectID, string FKTaskID, string ApproveStatus, string Billed, Int64 FKInvoiceID, Int64 FKSubmitToID, Int64 FKAssignLogID, string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTimesheet", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKEmpID, FKClientID, FKProjectID, FKTaskID, ApproveStatus, Billed, FKInvoiceID, FKSubmitToID, FKAssignLogID, RecType);
            return db.ExecuteDataSet(dbcommand);


        }

        public DataSet InsertTimesheet(Int64 FKEmpID, Int64 FKManagerID, string SubmitType,string ApproveAction,string ApproveRemark,string TaskStatus,Int64 FKAssignLogID, object dtItem, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertTimesheet", FKEmpID, FKManagerID, SubmitType, ApproveAction, ApproveRemark, TaskStatus, FKAssignLogID, dtItem,FKCompanyID, FKUserID, FKPageID, IPAddress,false);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetExpensesLog(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKEmpID, string FKClientID, string FKProjectID, string FKTaskID, string ApproveStatus, string Billed,string Remb, Int64 FKInvoiceID, string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetExpensesLog", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKEmpID, FKClientID, FKProjectID, FKTaskID, ApproveStatus, Billed, Remb, FKInvoiceID, RecType);
            return db.ExecuteDataSet(dbcommand);


        }
        public DataSet InsertExpensesLog(Int64 FKEmpID, string ApproveAction, string ApproveRemark, object dtItem, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertExpensesLog", FKEmpID, ApproveAction, ApproveRemark, dtItem, FKCompanyID, FKUserID, FKPageID, IPAddress, false);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet DeleteExpenseEntry(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteExpenseEntry", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetTaskAssignment(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKEmpID, string FKClientID, string FKProjectID, string FKTaskID, string CurrentStatus, Int64 FKManagerID,string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTaskAssignment", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKEmpID, FKClientID, FKProjectID, FKTaskID, CurrentStatus, FKManagerID, RecType);
            return db.ExecuteDataSet(dbcommand);


        }
        public DataSet InsertTaskAssignment(Int64 FKEmpID, Int64 FKManagerID, object dtItem, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertTaskAssignment", FKEmpID, FKManagerID, dtItem, FKCompanyID, FKUserID, FKPageID, IPAddress, false);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteTaskAssignment(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteTaskAssignment", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteAssignmentLog(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteAssignmentLog", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }

        //Added by Nilesh - new function and new sp for Deleting timesheet entry - Start
        public DataSet DeleteTimesheetEntry(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteTimesheetEntry", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        //Added by Nilesh - new function and new sp for Deleting timesheet entry - End
    }
}
