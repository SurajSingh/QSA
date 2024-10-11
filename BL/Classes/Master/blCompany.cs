using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace BL.Master
{
   public class blCompany : DAL.clsDAL
    {
        private Int64 _InvoiceSNo,_PKCompanyID, _PKBranchID,_FKTahsilID, _FKCityID, _FKStateID, _FKCountryID, _FKBusinessTypeID, _FKTimezoneID, _FKCurrencyID,_FKPartyID, _DiffParty;
        private string _InvoicePrefix, _InvoiceSuffix,_StrLocation, _CompanyID, _CompanyName, _Address1, _Address2, _ZIP, _Mobile, _Phone, _Email, _CPerson, _CPersonTitle, _GSTNo, _PANNo, _LogoURL, _RegDate, _DateForStr,_Website;
        private object _dtConfig;
        bool _IsCompanyInfSame, _IsDiffParty, _IsEComWebsite;

        public object dtConfig { get { return this._dtConfig; } set { this._dtConfig = value; } }

        public Int64 InvoiceSNo { get { return this._InvoiceSNo; } set { this._InvoiceSNo = value; } }
        public Int64 PKCompanyID { get { return this._PKCompanyID; } set { this._PKCompanyID = value; } }
        public Int64 PKBranchID { get { return this._PKBranchID; } set { this._PKBranchID = value; } }
        public Int64 FKTahsilID { get { return this._FKTahsilID; } set { this._FKTahsilID = value; } }
        public Int64 FKCityID { get { return this._FKCityID; } set { this._FKCityID = value; } }
        public Int64 FKStateID { get { return this._FKStateID; } set { this._FKStateID = value; } }
        public Int64 FKCountryID { get { return this._FKCountryID; } set { this._FKCountryID = value; } }
        public Int64 FKBusinessTypeID { get { return this._FKBusinessTypeID; } set { this._FKBusinessTypeID = value; } }
        public Int64 FKTimezoneID { get { return this._FKTimezoneID; } set { this._FKTimezoneID = value; } }
        public Int64 FKCurrencyID { get { return this._FKCurrencyID; } set { this._FKCurrencyID = value; } }
        public Int64 FKPartyID { get { return this._FKPartyID; } set { this._FKPartyID = value; } }
        public Int64 DiffParty { get { return this._DiffParty; } set { this._DiffParty = value; } }

        public bool IsEComWebsite { get { return this._IsEComWebsite; } set { this._IsEComWebsite = value; } }
        public bool IsCompanyInfSame { get { return this._IsCompanyInfSame; } set { this._IsCompanyInfSame = value; } }
        public bool IsDiffParty { get { return this._IsDiffParty; } set { this._IsDiffParty = value; } }


        public string InvoicePrefix { get { return this._InvoicePrefix; } set { this._InvoicePrefix = value.Trim(); } }
        public string InvoiceSuffix { get { return this._InvoiceSuffix; } set { this._InvoiceSuffix = value.Trim(); } }
       
        public string StrLocation { get { return this._StrLocation; } set { this._StrLocation = value.Trim(); } }
        public string CompanyID { get { return this._CompanyID; } set { this._CompanyID = value.Trim(); } }
        public string CompanyName { get { return this._CompanyName; } set { this._CompanyName = value.Trim(); } }
        public string Address1 { get { return this._Address1; } set { this._Address1 = value.Trim(); } }
        public string Address2 { get { return this._Address2; } set { this._Address2 = value.Trim(); } }
        public string ZIP { get { return this._ZIP; } set { this._ZIP = value.Trim(); } }
        public string Mobile { get { return this._Mobile; } set { this._Mobile = value.Trim(); } }
        public string Phone { get { return this._Phone; } set { this._Phone = value.Trim(); } }
        public string Email { get { return this._Email; } set { this._Email = value.Trim(); } }
        public string CPerson { get { return this._CPerson; } set { this._CPerson = value.Trim(); } }
        public string CPersonTitle { get { return this._CPersonTitle; } set { this._CPersonTitle = value.Trim(); } }
        public string GSTNo { get { return this._GSTNo; } set { this._GSTNo = value.Trim(); } }
        public string PANNo { get { return this._PANNo; } set { this._PANNo = value.Trim(); } }
        public string LogoURL { get { return this._LogoURL; } set { this._LogoURL = value.Trim(); } }
        public string RegDate { get { return this._RegDate; } set { this._RegDate = value.Trim(); } }
        public string DateForStr { get { return this._DateForStr; } set { this._DateForStr = value.Trim(); } }
        public string Website { get { return this._Website; } set { this._Website = value.Trim(); } }

        public DataSet GetConfiguration(string ApplyOn)
        {
            dbcommand = db.GetStoredProcCommand("uspGetConfiguration", PKCompanyID, ApplyOn,PKBranchID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertConfiguration()
        {
            dbcommand = db.GetStoredProcCommand("uspInsertConfiguration",dtConfig, PKCompanyID,PKBranchID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
     

        public DataSet UpdateCompany()
        {
            dbcommand = db.GetStoredProcCommand("uspUpdateCompany", PKCompanyID, CompanyID, CompanyName, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, Mobile, Phone, Email, CPerson, CPersonTitle, GSTNo, PANNo, LogoURL,Website, FKTimezoneID, FKCurrencyID, DateForStr);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertEmailSettings(string SenderEmail, string SenderPWD, string SMTPServer, Int32 SMTPPort, bool EnableSSL)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertEmailSettings", PKCompanyID, SenderEmail, SenderPWD, SMTPServer, SMTPPort, EnableSSL);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetCompanybyId()
        {
            dbcommand = db.GetSqlStringCommand(string.Format("SELECT * FROM tblCompany WHERE CompanyID = '{0}'", CompanyID));
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetCompany()
        {
            dbcommand = db.GetStoredProcCommand("uspGetCompany", PKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetBranch()
        {
            dbcommand = db.GetStoredProcCommand("uspGetBranch", PKBranchID, PKCompanyID,DiffParty);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetCompanyDashboard()
        {
            dbcommand = db.GetStoredProcCommand("uspGetCompanyDashboard", PKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet UploadCompanyLogo(string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspUploadCompanyLogo", RecType,LogoURL, PKCompanyID, FKUserID,FKPageID,IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
      
        public DataSet GetCompanyForReport()
        {
            dbcommand = db.GetStoredProcCommand("uspGetCompanyForReport", PKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet SaveCompanyPage(string PageStr)
        {
            dbcommand = db.GetStoredProcCommand("uspSaveCompanyPage",  PKCompanyID,PageStr);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetEmailMsgLocation(string strLocation)
        {
            dbcommand = db.GetStoredProcCommand("uspGetEmailMsgLocation", strLocation);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetEmailSettings()
        {
            dbcommand = db.GetStoredProcCommand("uspGetEmailSettings", PKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetSMSSettings()
        {
            dbcommand = db.GetStoredProcCommand("uspGetSMSSettings", PKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetEmailTemplate(Int64 FKEmailMsgLocID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetEmailTemplate", PKCompanyID, FKEmailMsgLocID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetSMSTemplate(Int64 FKEmailMsgLocID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetSMSTemplate", PKCompanyID, FKEmailMsgLocID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet UpdateBillingSettings()
        {
            dbcommand = db.GetStoredProcCommand("uspUpdateBillingSettings", PKCompanyID, InvoicePrefix, InvoiceSuffix, InvoiceSNo);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet UpdateInvoiceTemplate()
        {
            dbcommand = db.GetStoredProcCommand("uspUpdateInvoiceTemplate", PKCompanyID, InvoiceSNo);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertSMSSettings(string API)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertSMSSettings", PKCompanyID, API);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertEmailTemplate(Int64 FKEmailMsgLocID,string BodyContent, string EmailSubject, bool EnableEmail, string Receiver)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertEmailTemplate", PKCompanyID, FKEmailMsgLocID, BodyContent, EmailSubject, EnableEmail, Receiver);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertSMSTemplate(Int64 FKEmailMsgLocID, string BodyContent, bool EnableEmail)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertSMSTemplate", PKCompanyID, FKEmailMsgLocID, BodyContent, EnableEmail);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetPrintLayout(Int64 FKTranTypeID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetPrintLayout", PKCompanyID,FKTranTypeID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet UpdateAttendanceSetting(string UserName,string PWD)
        {
            dbcommand = db.GetStoredProcCommand("uspUpdateAttendanceSetting", PKCompanyID, UserName, PWD);
            return db.ExecuteDataSet(dbcommand);
        }


        public DataSet InsertAnnouncement(Int64 PKID, string Title,object DisplayDate,string Announcement, string ActiveStatus, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertAnnouncement", PKID, Title, DisplayDate, Announcement, ActiveStatus, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteAnnouncement(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteAnnouncement", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetAnnouncement(Int64 PKID, bool ForDisplay, bool ForRead,Int64 FKUserID,Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetAnnouncement", PKID, ForDisplay, ForRead, FKUserID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetNotification(Int64 FKUserID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetNotification", FKUserID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
       
    }
}
