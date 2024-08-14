using System.Data.SqlClient;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data.Common;
using System.Data;
using System;
namespace BL.DAL
{
    public class clsDAL
    {
        public static string connString = "";
        public DbCommand dbcommand;
        public SqlDatabase db = null;
        public static SqlConnection scon =null ;
        public clsDAL()
        {
            db = new SqlDatabase(connString);
            scon = new SqlConnection(connString); 
        }
        private Int64 _FKPageID,_FKUserID,_PKID;
        private string _IPAddress, _MACAddr;
        private bool _IsDraft;
        public bool IsDraft { get { return this._IsDraft; } set { this._IsDraft = value; } }
        public Int64 FKPageID { get { return this._FKPageID; } set { this._FKPageID = value; } }
        public Int64 FKUserID { get { return this._FKUserID; } set { this._FKUserID = value; } }
        public Int64 PKID { get { return this._PKID; } set { this._PKID = value; } }
        public string IPAddress { get { return this._IPAddress; } set { this._IPAddress = value.Trim(); } }
        public string MACAdd { get { return this._MACAddr; } set { this._MACAddr = value.Trim(); } }
    }
}