using System;
using System.Data;

namespace BL.Report
{
    public class blAgingReport : DAL.clsDAL
    {
        public DataSet GetAgingReport(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir,string ColStr, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKClientID, string FKProjectID, string InvoiceID, string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetAgingReport", PageSize, PageNo, SortBy, SortDir, ColStr, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKClientID, FKProjectID, InvoiceID, RecType);
            return db.ExecuteDataSet(dbcommand);


        }
    }
}
