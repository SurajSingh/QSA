using System;
using System.Data;

namespace BL.Payroll
{
    public class blPayroll : DAL.clsDAL
    {

        public DataSet InsertHoliday(Int64 PKID, object HolidayDate, string Name, string DeptDesc, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertHoliday", PKID, HolidayDate, Name, DeptDesc, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteHoliday(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteHoliday", PKID, FKUserID, FKCompanyID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetHoliday(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetHoliday", PKID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }


        public DataSet InsertPayrollSetting(Int64 PKID, string StartMonth, string EndMonth, string LeaveRule, object dtItem, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertPayrollSetting", PKID, StartMonth, EndMonth, LeaveRule, dtItem, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetPayrollSetting(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetPayrollSetting", PKID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);


        }

       
        public DataSet InsertLeaveRequest(Int64 PKID,object FromDate, object ToDate, Int64 FKEmpID, Int64 FKLeaveID,decimal LeaveCount,string Remarks,string ApproveStatus,Int64 FKApproveBy, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertLeaveRequest", PKID, FromDate, ToDate, FKEmpID, FKLeaveID, LeaveCount, Remarks, ApproveStatus, FKApproveBy, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteLeaveRequest(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteLeaveRequest", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetLeaveRequest(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, Int64 FKEmpID, Int64 FKLeaveID, string LeaveType, string ApproveStatus)
        {
            dbcommand = db.GetStoredProcCommand("uspGetLeaveRequest", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKEmpID, FKLeaveID, LeaveType, ApproveStatus);
            return db.ExecuteDataSet(dbcommand);


        }
        public DataSet GetEmpLeaveReport(Int64 FKCompanyID,Int64 FKEmpID,Int64 FKLeaveID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetEmpLeaveReport", FKCompanyID, FKEmpID, FKLeaveID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet CalculateEmployeeLeave(Int64 FKLeaveID,Int64 FKEmpID,object FromDate,decimal NoOfDays, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspCalculateEmployeeLeave", FKLeaveID, FKEmpID, FromDate, NoOfDays, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet ApproveLeaveRequest(Int64 PKID,string ApproveStatus,string Remarks, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspApproveLeaveRequest", PKID,ApproveStatus,Remarks, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
    }
}
