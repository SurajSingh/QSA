using System;
using System.Data;

namespace BL.Report
{
    public class blBudgetReport : DAL.clsDAL
    {
        public DataSet GetBudgetReport(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, string FKProjectID,string FKClientID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetBudgetReport", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKProjectID, FKClientID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);


        }
        public DataSet GetBudgetDetailReport(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, string FKProjectID, string FKClientID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetBudgetDetailReport", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKProjectID, FKClientID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);


        }
    }
}
