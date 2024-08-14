using System;
using System.Data;

namespace BL.ProjectManagement
{
    public class blProjectManagement : DAL.clsDAL
    {

        public DataSet GetProjectModule(Int64 PKID, Int64 FKCompanyID,Int64 FKParentID,Int64 FKProjectID,string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetProjectModule", PKID, FKCompanyID, FKParentID, FKProjectID, RecType);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertProjectModule(Int64 PKID, Int64 FKProjectID, string ModuleName, string ModuleDesc, Int64 FKParentID,Int64 FKTaskID,object EstStartDate,object EstEndDate,decimal EstHrs,decimal CompletePer,string TaskStatus,string RecType, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertProjectModule", PKID, FKProjectID, ModuleName.Trim(), ModuleDesc.Trim(), FKParentID, FKTaskID, EstStartDate, EstEndDate, EstHrs, CompletePer, TaskStatus, RecType,FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet AssignProjectModule(Int64 PKID, Int64 FKEmpID, Int64 FKManagerID, object AssignDate, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspAssignProjectModule", PKID, FKEmpID, FKManagerID, AssignDate, FKCompanyID, FKUserID, FKPageID, IPAddress,false);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet UpdateModuleStatus(Int64 PKID, string NewStatus, object NewDate, Int64 CompletePer, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspUpdateModuleStatus", PKID, NewStatus, NewDate, CompletePer, FKCompanyID, FKUserID, FKPageID, IPAddress, false);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet DeleteProjectModule(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteProjectModule", PKID, FKUserID, FKCompanyID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetBudgetForAutoComplete(Int64 FKProjectID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetBudgetForAutoComplete", FKProjectID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);


        }
        public DataSet GetProjectBudget(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, Int64 PKID,Int64 FKProjectID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetProjectBudget", PageSize, PageNo, SortBy, SortDir, PKID, FKProjectID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);


        }

        public DataSet DeleteProjectBudget(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteProjectBudget", PKID, FKUserID, FKCompanyID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet InsertProductBudget(Int64 PKID, string BudgetTitle, object FromDate, object ToDate, Int64 FKProjectID, object dtItem, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertProductBudget", PKID, BudgetTitle.Trim(), FromDate, ToDate, FKProjectID, dtItem, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }


        public DataSet GetProjectForcastingReport(Int64 PKID, Int64 FKCompanyID, string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetProjectForcastingReport", PKID, FKCompanyID,  RecType);
            return db.ExecuteDataSet(dbcommand);
        }
    }
}
