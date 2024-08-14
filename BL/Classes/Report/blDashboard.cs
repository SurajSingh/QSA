using System;
using System.Data;


namespace BL.Report
{
    public class blDashboard : DAL.clsDAL
    {
        public DataSet GetDashboard(Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetDashboard", FKCompanyID, FKUserID);
            return db.ExecuteDataSet(dbcommand);
        }
       
    }
}
