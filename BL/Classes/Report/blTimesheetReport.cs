using System;
using System.Data;

namespace BL.Report
{
    public class blTimesheetReport : DAL.clsDAL
    {
        public DataSet GetTimesheetReport(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir,string ColStr, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKEmpID, string FKClientID, string FKProjectID, string FKTaskID, string ApproveStatus, string Billed, string Billable,  string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTimesheetReport", PageSize, PageNo, SortBy, SortDir, ColStr, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKEmpID, FKClientID, FKProjectID, FKTaskID, ApproveStatus, Billed, Billable, RecType);
            return db.ExecuteDataSet(dbcommand);


        }
        public DataSet GetTimeandExpReport(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, string ColStr, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKEmpID, string FKClientID, string FKProjectID, string FKTaskID,Int64 FKManagerID, string ApproveStatus, string Billed, string Billable, string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTimeandExpReport", PageSize, PageNo, SortBy, SortDir, ColStr, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKEmpID, FKClientID, FKProjectID, FKTaskID, FKManagerID, ApproveStatus, Billed, Billable, RecType);
            return db.ExecuteDataSet(dbcommand);


        }
    }
}
