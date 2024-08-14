using System;
using System.Data;


namespace BL.Master
{
   public class blGetMaster : DAL.clsDAL
    {
        public DataSet GetEmpForAutoComplate(Int64 PKID,string ActiveStatus, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetEmpForAutoComplate", PKID, ActiveStatus, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetClientForAutoComplete(Int64 PKID, string ActiveStatus, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetClientForAutoComplete", PKID, ActiveStatus, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetProjectForAutoComplete(Int64 PKID, string ActiveStatus, Int64 FKClientID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetProjectForAutoComplete", PKID, ActiveStatus, FKClientID,FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetProjectDetail(Int64 PKID, Int64 FKProjectID, Int64 FKCompanyID, object InvFromDate, object InvToDate)
        {
            dbcommand = db.GetStoredProcCommand("uspGetProjectDetail", PKID, FKProjectID, FKCompanyID,InvFromDate,InvToDate);

            return db.ExecuteDataSet(dbcommand);
        }
        //Added by nilesh to get all unbilled task on demand - 20/04/2024 - STart
        public DataSet GetAllUnbilledTask(Int64 PKID, Int64 FKProjectID, Int64 FKCompanyID, object InvFromDate, object InvToDate)
        {
            dbcommand = db.GetStoredProcCommand("uspGetUnBilledTasks", PKID, FKProjectID, FKCompanyID, InvFromDate, InvToDate);

            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetAllUnbilledExpenses(Int64 PKID, Int64 FKProjectID, Int64 FKCompanyID, object InvFromDate, object InvToDate)
        {
            dbcommand = db.GetStoredProcCommand("uspGetUnBilledExpense", PKID, FKProjectID, FKCompanyID, InvFromDate, InvToDate);

            return db.ExecuteDataSet(dbcommand);
        }
        //Added by nilesh to get all unbilled task on demand - 20/04/2024 - End
        public DataSet GetTaskForAutoComplete(Int64 PKID, Int64 FKDeptID,string TEType   ,string ActiveStatus, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTaskForAutoComplete", PKID, FKDeptID, TEType ,ActiveStatus, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
    }
}
