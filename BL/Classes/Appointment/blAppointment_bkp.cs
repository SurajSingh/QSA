using System;
using System.Data;
namespace BL.Appointment
{
    public class blAppointment : DAL.clsDAL
    {
        public DataSet GetAppointmentAvailability(bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, Int64 FKEmpID,string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetAppointmentAvailability", DateWise, FromDate, ToDate, PKID, FKCompanyID, FKEmpID, RecType);
            return db.ExecuteDataSet(dbcommand);

        }
        public DataSet InsertAppointmentAvailability(Int64 FKEmpID, object dtItem, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertAppointmentAvailability", FKEmpID, dtItem, FKCompanyID, FKUserID, FKPageID, IPAddress, false);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetAppointment(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKEmpID, Int64 FKIntervalID, string ApproveStatus)
        {
            dbcommand = db.GetStoredProcCommand("uspGetAppointment", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKEmpID, FKIntervalID,ApproveStatus);
            return db.ExecuteDataSet(dbcommand);


        }
        public DataSet InsertAppointment(Int64 PKID, Int64 FKEmpID, Int64 FKIntervalID,object OnDate,object FromTime,object ToTime,string CutomerName, string CompanyName, string EmailID, string Mobile, string Remarks, string ApproveStatus, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertAppointment", PKID, FKEmpID, FKIntervalID, OnDate, FromTime, ToTime, CutomerName, CompanyName, EmailID, Mobile, Remarks, ApproveStatus, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteAppointment(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteAppointment", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet UpdateAppointmentStatus(Int64 FKCompanyID,Int64 PKID,string ApproveStatus)
        {
            dbcommand = db.GetStoredProcCommand("uspUpdateAppointmentStatus", FKCompanyID,PKID, ApproveStatus);
            return db.ExecuteDataSet(dbcommand);
        }
    }
}
