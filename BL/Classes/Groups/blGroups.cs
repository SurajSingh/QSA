using System;
using System.Data;

namespace BL.Groups
{
    public class blGroups : DAL.clsDAL
    {
        public DataSet InsertGroups(Int64 PKID, string GroupName, string Description,string GroupItems,string RecType, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertGroups", PKID, GroupName.Trim(), Description.Trim(), GroupItems, RecType, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteGroups(Int64 PKID, string RecType,Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteGroups", PKID, RecType, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetGroups(Int64 PKID, Int64 FKDtlID,string RecType, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetGroups", PKID, FKDtlID, RecType, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
    }
}
