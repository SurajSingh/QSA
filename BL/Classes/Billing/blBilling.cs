using System;
using System.Data;
namespace BL
{
    public class blBilling : DAL.clsDAL
    {
        public DataSet InsertInvoice(Int64 PKID,object InvDate, Int64 FKProjectID, Int64 SNo,string Prefix,string Suffix,string CPerson,string CPersonTitle,string Address1,string Address2, Int64 FKTahsilID, Int64 FKCityID, Int64 FKStateID, Int64 FKCountryID,string ZIP,decimal SubAmt, Int64 FKTaxID,decimal TaxPer, decimal TaxAmt,decimal Amount,decimal Discount,decimal NetAmount,decimal Retainage,string Remarks, Int64 FKCurrencyID,string StrTimeEntries,string StrExpenseEntries,object dtItem, Int64 FKCompanyID, Int64 IsDeleted, Int64 IsArchieved, Int64 FKManagerID, string SubmitType, string ApproveAction, string ApproveRemark,object InvFromDate, object InvToDate)
        {
            //Added two extra paratmeter to set the Isdeleted and IsArchieved value which is by default 0
            dbcommand = db.GetStoredProcCommand("uspInsertInvoice", PKID, InvDate, FKProjectID, SNo, Prefix, Suffix, CPerson, CPersonTitle, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, SubAmt, FKTaxID, TaxPer,TaxAmt, Amount, Discount, NetAmount, Retainage, Remarks, FKCurrencyID, StrTimeEntries,StrExpenseEntries, dtItem, FKCompanyID, FKUserID, FKPageID, IPAddress, IsDeleted, IsArchieved, FKManagerID, SubmitType, ApproveAction, ApproveRemark,InvFromDate,InvToDate);
            return db.ExecuteDataSet(dbcommand);
        }        
    public DataSet ApproveInvoices(Int64 PKID, Int64 FKUSerID, string ApproveAction, string ApproveRemark, Int64 FKCompanyID)
        {
            //Added two extra paratmeter to set the Isdeleted and IsArchieved value which is by default 0
            dbcommand = db.GetStoredProcCommand("uspApproveInvoice", PKID, FKUSerID, ApproveAction, ApproveRemark, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetInvoice(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID,  string FKClientID, string FKProjectID, string InvoiceID, Int64 FKPaymentID, string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetInvoice", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKClientID, FKProjectID, InvoiceID, FKPaymentID, RecType);
            return db.ExecuteDataSet(dbcommand);

            
        }
        public DataSet DeleteInvoice(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteInvoice", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        

        //Added by Nilesh to implement Archival process - start
        public DataSet ArchiveInvoice(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspArchiveInvoice", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetInvoiceArchived(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKClientID, string FKProjectID, string InvoiceID, Int64 FKPaymentID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetInvoiceArchived", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKClientID, FKProjectID, InvoiceID, FKPaymentID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet RevokeArchiveInvoice(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspRevokeArchiveInvoice", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetInvoiceDeleted(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKClientID, string FKProjectID, string InvoiceID, Int64 FKPaymentID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetInvoiceDeleted", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKClientID, FKProjectID, InvoiceID, FKPaymentID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet RevokeDeletedInvoice(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspRevokeDeletedInvoice", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet PermanentlyDeletedInvoice(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteInvoicePermanently", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        //Added by Nilesh to81441 -5754implement Archival process - End

        public DataSet InsertPayment(Int64 PKID, Int64 FKClientID,object TranDate, Int64 FKPaymentTypeID, Int64 FKPaymodeID,string TranID,bool IsRetainer,decimal Amount,decimal RetainerAmount, object dtItem, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertPayment", PKID, FKClientID, TranDate, FKPaymentTypeID, FKPaymodeID, TranID, IsRetainer, Amount, RetainerAmount,dtItem, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetPayment(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKClientID, string PayID, Int64 FKPaymentTypeID, Int64 FKPaymodeID, string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetPayment", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKClientID, PayID, FKPaymentTypeID, FKPaymodeID , RecType);
            return db.ExecuteDataSet(dbcommand);

          
        }
        public DataSet GetInvForAdjustment(Int64 PKID, Int64 FKClientID, Int64 FKProjectID,Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetInvForAdjustment", PKID,FKClientID,FKProjectID,FKCompanyID);
            return db.ExecuteDataSet(dbcommand);


        }
        public DataSet DeletePayment(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeletePayment", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }


        public DataSet GetTransaction(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, bool DateWise, object FromDate, object ToDate, Int64 PKID, Int64 FKCompanyID, string FKClientID, string FKProjectID, string InvoiceID, string PayID,string TranType, string RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTransaction", PageSize, PageNo, SortBy, SortDir, DateWise, FromDate, ToDate, PKID, FKCompanyID, FKClientID, FKProjectID, InvoiceID, PayID, TranType, RecType);
            return db.ExecuteDataSet(dbcommand);


        }
    }
}
