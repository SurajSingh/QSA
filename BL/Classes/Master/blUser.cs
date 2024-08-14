using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BL.Master
{
    public class blUser : DAL.clsDAL
    {
        private Int64 _FKCurrencyID,_FKManagerID, _FKSubmitToID,_FKParentID, _FKDashboardID, _FKTahsilID, _FKCityID, _FKStateID, _FKCountryID, _PKUserID, _PKRoleGroupID, _FKRoleGroupID, _FKDeptID, _FKDesigID, _FKTimeZoneID, _FKCompanyID, _FKBranchID;
        private string _AddressTitle,_PayPeriod, _Remark, _Gender, _FName, _MName, _LName, _EnrollNo,_Address1, _Address2, _ZIP,_OrgTypeID, _BranchStr, _DtRoleXML,_GroupName, _LoginID, _EmailID, _PWD, _PWDNew, _Name, _MobNo, _Phone1, _Phone2, _RoleType, _RecordType, _ActiveStatus, _PhotoURL;
        private bool _IsDefaultUser, _ForAppointment;
        object _DOB, _JoinDate, _ReleasedDate;
        decimal _BillRate, _PayRate, _OverTimeBillRate, _OverTimePayrate, _OverheadMulti, _SalaryAmount;
        #region Properties

        public decimal BillRate { get { return this._BillRate; } set { this._BillRate = value; } }
        public decimal PayRate { get { return this._PayRate; } set { this._PayRate = value; } }
        public decimal OverTimeBillRate { get { return this._OverTimeBillRate; } set { this._OverTimeBillRate = value; } }
        public decimal OverTimePayrate { get { return this._OverTimePayrate; } set { this._OverTimePayrate = value; } }
        public decimal OverheadMulti { get { return this._OverheadMulti; } set { this._OverheadMulti = value; } }
       
        public decimal SalaryAmount { get { return this._SalaryAmount; } set { this._SalaryAmount = value; } }

        public object DOB { get { return this._DOB; } set { this._DOB = value; } }
        public object JoinDate { get { return this._JoinDate; } set { this._JoinDate = value; } }
        public object ReleasedDate { get { return this._ReleasedDate; } set { this._ReleasedDate = value; } }

        public Int64 FKCurrencyID { get { return this._FKCurrencyID; } set { this._FKCurrencyID = value; } }
        public Int64 FKManagerID { get { return this._FKManagerID; } set { this._FKManagerID = value; } }
        public Int64 FKSubmitToID { get { return this._FKSubmitToID; } set { this._FKSubmitToID = value; } }
        public Int64 FKTahsilID { get { return this._FKTahsilID; } set { this._FKTahsilID = value; } }
        public Int64 FKCityID { get { return this._FKCityID; } set { this._FKCityID = value; } }
        public Int64 FKStateID { get { return this._FKStateID; } set { this._FKStateID = value; } }
        public Int64 FKCountryID { get { return this._FKCountryID; } set { this._FKCountryID = value; } }
        public Int64 FKDashboardID
        {
            get { return this._FKDashboardID; }
            set { this._FKDashboardID = value; }
        }
        public Int64 FKParentID { get { return this._FKParentID; } set { this._FKParentID = value; } }
        public Int64 PKUserID { get { return this._PKUserID; } set { this._PKUserID = value; } }
        public Int64 FKRoleGroupID { get { return this._FKRoleGroupID; } set { this._FKRoleGroupID = value; } }       
        public Int64 FKCompanyID { get { return this._FKCompanyID; } set { this._FKCompanyID = value; } }     
        public Int64 PKRoleGroupID { get { return this._PKRoleGroupID; } set { this._PKRoleGroupID = value; } }

        public Int64 FKDeptID { get { return this._FKDeptID; } set { this._FKDeptID = value; } }
        public Int64 FKDesigID { get { return this._FKDesigID; } set { this._FKDesigID = value; } }
        public Int64 FKTimeZoneID { get { return this._FKTimeZoneID; } set { this._FKTimeZoneID = value; } }
        public Int64 FKBranchID { get { return this._FKBranchID; } set { this._FKBranchID = value; } }


        public bool IsDefaultUser { get { return this._IsDefaultUser; } set { this._IsDefaultUser = value; } }
        public bool ForAppointment { get { return this._ForAppointment; } set { this._ForAppointment = value; } }

        public string AddressTitle { get { return this._AddressTitle; } set { this._AddressTitle = value.Trim(); } }
        public string PayPeriod { get { return this._PayPeriod; } set { this._PayPeriod = value.Trim(); } }
        public string Remark { get { return this._Remark; } set { this._Remark = value.Trim(); } }
        public string Address1 { get { return this._Address1; } set { this._Address1 = value.Trim(); } }
        public string Gender { get { return this._Gender; } set { this._Gender = value.Trim(); } }
        public string Address2 { get { return this._Address2; } set { this._Address2 = value.Trim(); } }
        public string ZIP { get { return this._ZIP; } set { this._ZIP = value.Trim(); } }
        public string OrgTypeID { get { return this._OrgTypeID; } set { this._OrgTypeID = value.Trim(); } }
        public string BranchStr { get { return this._BranchStr; } set { this._BranchStr = value.Trim(); } }
        public string LoginID { get { return this._LoginID; } set { this._LoginID = value.Trim(); } }
        public string EmailID { get { return this._EmailID; } set { this._EmailID = value.Trim(); } }
        public string PWD { get { return this._PWD; } set { this._PWD = value.Trim(); } }
        public string PWDNew { get { return this._PWDNew; } set { this._PWDNew = value.Trim(); } }
        public string Name { get { return this._Name; } set { this._Name = value.Trim(); } }
        public string MobNo { get { return this._MobNo; } set { this._MobNo = value.Trim(); } }
        public string Phone1 { get { return this._Phone1; } set { this._Phone1 = value.Trim(); } }
        public string Phone2 { get { return this._Phone2; } set { this._Phone2 = value.Trim(); } }
        public string RoleType { get { return this._RoleType; } set { this._RoleType = value.Trim(); } }
        public string RecordType { get { return this._RecordType; } set { this._RecordType = value.Trim(); } }
        public string ActiveStatus { get { return this._ActiveStatus; } set { this._ActiveStatus = value.Trim(); } }
        
        public string PhotoURL { get { return this._PhotoURL; } set { this._PhotoURL = value.Trim(); } }
        public string GroupName { get { return this._GroupName; } set { this._GroupName = value.Trim(); } }     
        public string DtRoleXML { get { return this._DtRoleXML; } set { this._DtRoleXML = value.Trim(); } }
        public string FName { get { return this._FName; } set { this._FName = value.Trim(); } }
        public string MName { get { return this._MName; } set { this._MName = value.Trim(); } }
        public string LName { get { return this._LName; } set { this._LName = value.Trim(); } }
        public string EnrollNo { get { return this._EnrollNo; } set { this._EnrollNo = value.Trim(); } }
        #endregion

        #region Methods
        public DataSet InsertRoleGroup()
        {
            dbcommand = db.GetStoredProcCommand("uspInsertRoleGroup", PKRoleGroupID, GroupName,OrgTypeID, FKCompanyID, DtRoleXML, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteRoleGroup()
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteRoleGroup", PKRoleGroupID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetAllRoleGroup()
        {
            dbcommand = db.GetStoredProcCommand("uspGetAllRoleGroup", PKRoleGroupID, OrgTypeID,FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertUser()
        {
            dbcommand = db.GetStoredProcCommand("uspInsertUser", PKUserID, LoginID, EmailID, PWD, FName, MName, LName, EnrollNo, DOB, Gender, MobNo, Phone1, Phone2, AddressTitle, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, JoinDate, ReleasedDate, FKManagerID, FKSubmitToID, OrgTypeID, RoleType, FKRoleGroupID, FKCompanyID, FKDeptID, FKDesigID, FKTimeZoneID, Remark, ForAppointment, IsDefaultUser, FKDashboardID, ActiveStatus, BillRate, PayRate, OverTimeBillRate, OverTimePayrate, OverheadMulti, FKCurrencyID, PayPeriod, SalaryAmount,
               FKUserID,IPAddress, MACAdd, FKPageID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet UpdateProfile()
        {
            dbcommand = db.GetStoredProcCommand("uspUpdateProfile", PKUserID, EmailID, Name, MobNo, Phone1, Phone2,
                PhotoURL, IPAddress, MACAdd, FKPageID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet ValidateResetPasswordToken(string ResetPwdToken)
        {
            dbcommand = db.GetStoredProcCommand("uspValidateResetPasswordToken", ResetPwdToken);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet ResetPassword(string ResetPwdToken)
        {
            dbcommand = db.GetStoredProcCommand("uspResetPassword", ResetPwdToken, PWDNew);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet ChangePassword()
        {
            dbcommand = db.GetStoredProcCommand("uspChangePassword", PKUserID, PWD, PWDNew);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet UpdatePassword()
        {
            dbcommand = db.GetStoredProcCommand("uspUpdatePassword", LoginID, PWD);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetUser(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir)
        {
            dbcommand = db.GetStoredProcCommand("uspGetUser", PageSize, PageNo, SortBy, SortDir, PKUserID, Name, FKRoleGroupID, ActiveStatus, FKDeptID,FKDesigID, FKCompanyID, FKParentID, OrgTypeID, ForAppointment);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteUser()
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteUser", PKUserID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }


        public DataSet Login()
        {
            dbcommand = db.GetStoredProcCommand("uspLogin", LoginID, PWD, IPAddress, MACAdd);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet LoginWithToken()
        {
            dbcommand = db.GetStoredProcCommand("uspLoginWithToken", LoginID, PWD,RecordType, IPAddress, MACAdd);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet Logout()
        {
            dbcommand = db.GetStoredProcCommand("uspLogout", PKUserID, IPAddress, MACAdd);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet CustomerLogin(Int64 FKPartyTypeID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetCustomerLogin", FKPartyTypeID, EmailID,MobNo, PWD,FKCompanyID, IPAddress, MACAdd);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet ValidateLoginWithToken()
        {
            dbcommand = db.GetStoredProcCommand("uspValidateLoginWithToken", PKUserID, LoginID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetUserByMobile()
        {
            dbcommand = db.GetStoredProcCommand("uspGetUserByMobile", MobNo);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetUserByID()
        {
            dbcommand = db.GetStoredProcCommand("uspGetUserByID", LoginID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetUserRoleAndPages()
        {
            dbcommand = db.GetStoredProcCommand("uspGetUserRoleAndPages", FKUserID, RoleType);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetUserDashboardLink()
        {
            dbcommand = db.GetStoredProcCommand("uspGetUserDashboardLink", FKUserID,FKCompanyID, RoleType);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet ValidateUserID()
        {
            dbcommand = db.GetStoredProcCommand("uspValidateUserID", LoginID, PKUserID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetRecentLog()
        {
            dbcommand = db.GetStoredProcCommand("uspGetRecentLog", FKUserID,FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetAdminDashboard()
        {
            dbcommand = db.GetStoredProcCommand("uspGetAdminDashboard", FKUserID, FKCompanyID, RoleType);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DashboardGetTopTasks(object FromDate,object ToDate)
        {
            dbcommand = db.GetStoredProcCommand("uspDashboardGetTopTasks", FKUserID, FKCompanyID, RoleType, FromDate, ToDate);
            return db.ExecuteDataSet(dbcommand);
        }

        //Adde by Nilesh

        public DataSet GetUserByID(string LoginID)
        {
            string SQL = String.Format("SELECT * FROM tblUser WHERE LoginID = '{0}'", LoginID);
            return db.ExecuteDataSet(CommandType.Text, SQL);
        }
        #endregion
    }
}
