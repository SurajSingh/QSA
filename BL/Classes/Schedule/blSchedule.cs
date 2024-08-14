using System;
using System.Data;

namespace BL.Schedule
{
    public class blSchedule : DAL.clsDAL
    {
        public DataSet GetWorkTypeMaster(Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetWorkTypeMaster", FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetScheduleStatusMaster()
        {
            dbcommand = db.GetStoredProcCommand("uspGetScheduleStatusMaster");
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertClientSchedule(Int64 PKID, Int64 FKProjectID,object FromDate,object ToDate,object FromTime, Int64 FKWorkTypeID, Int64 FKStatusID,string Remarks, string StrEmp, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertClientSchedule", PKID, FKProjectID, FromDate, ToDate, FromTime, FKWorkTypeID, FKStatusID, Remarks, StrEmp, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetClientSchedule(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID,string FKEmpID, string FKClientID, string FKProjectID, Int64 FKStatusID, Int64 FKWorkTypeID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetClientSchedule", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKEmpID, FKClientID, FKProjectID, FKStatusID, FKWorkTypeID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetClientScheduleDetail(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKEmpID, string FKClientID, string FKProjectID, Int64 FKStatusID, Int64 FKWorkTypeID,string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetClientScheduleDetail", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKEmpID, FKClientID, FKProjectID, FKStatusID, FKWorkTypeID, RecType);
            return db.ExecuteDataSet(dbcommand);


        }
        public DataSet DeleteClientSchedule(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteClientSchedule", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet UpdateScheduleStatus(Int64 PKID, Int64 FKCompanyID,Int64 FKStatusID)
        {
            dbcommand = db.GetStoredProcCommand("uspUpdateScheduleStatus", FKCompanyID, PKID, FKStatusID);
            return db.ExecuteDataSet(dbcommand);
        }

    }
}
