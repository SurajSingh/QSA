using System;
using System.Data;
namespace BL.Asset
{
    public class blAsset : DAL.clsDAL
    {
        public DataSet InsertAssetCategory(Int64 PKID, string Code,string Name, string AssetDesc, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertAssetCategory", PKID, Code,Name, AssetDesc, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteAssetCategory(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteAssetCategory", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetAssetCategory(Int64 PKID, string Name, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetAssetCategory", PKID, Name, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertAsset(Int64 PKID, string AssetCode, string AssetName, string AssetDesc, Int64 FKCategoryID, string Manufacturer, Int64 FKPartyID, decimal PurchaseRate, decimal CurrentRate, object PurchaseDate, string InvoiceID, string PONo, string Barcode, string SerialNo, string Remarks, string ImgURL, Int64 FKConditionID, Int64 FKLocationID, Int64 FKDeptID, Int64 FKEmpID, Int64 FKRepairPartyID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertAsset", PKID, AssetCode, AssetName, AssetDesc, FKCategoryID, Manufacturer, FKPartyID, PurchaseRate, CurrentRate, PurchaseDate, InvoiceID, PONo, Barcode, SerialNo, Remarks, ImgURL, FKConditionID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID, FKCompanyID,FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteAsset(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteAsset", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetAsset(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, Int64 PKID,string AssetCode, Int64 FKCategoryID, Int64 FKConditionID, Int64 FKLocationID, Int64 FKDeptID, Int64 FKEmpID, Int64 FKRepairPartyID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetAsset", PageSize, PageNo, SortBy, SortDir, PKID, AssetCode, FKCategoryID, FKConditionID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);


        }
        public DataSet GetAssetForAutoComplete(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetAssetForAutoComplete", PKID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        #region Vendor
        public DataSet InsertParty(Int64 PKID, string Code, string Company, string CPerson, string CPersonTitle, string Address1, string Address2, Int64 FKTahsilID, Int64 FKCityID, Int64 FKStateID, Int64 FKCountryID, string ZIP, string EMailID, string Phone1, string Phone2, string Mobile, string Fax, string Website, string Notes, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertParty", PKID, Code.Trim(), Company.Trim(), CPerson.Trim(), CPersonTitle.Trim(), Address1.Trim(), Address2.Trim(), FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, EMailID.Trim(), Phone1, Phone2, Mobile, Fax, Website.Trim(), Notes.Trim(), FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);

        }
        public DataSet DeleteParty(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteParty", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetParty(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, Int64 PKID, Int64 FKCompanyID, string Company)
        {
            dbcommand = db.GetStoredProcCommand("uspGetParty", PageSize, PageNo, SortBy, SortDir, PKID, FKCompanyID, Company);
            return db.ExecuteDataSet(dbcommand);

        }
        #endregion

        #region Location Transfer
        public DataSet InsertLocationTransfer(Int64 PKID, object TranDate, Int64 FKAssetID, Int64 FKLocationID, Int64 FKDeptID, Int64 FKEmpID, Int64 FKRepairPartyID, string Remarks, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertLocationTransfer", PKID, TranDate, FKAssetID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID,Remarks, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteLocationTransfer(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteLocationTransfer", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetLocationTransfer(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, Int64 PKID,bool DateWise,object FromDate,object ToDate, Int64 FKAssetID,string AssetCode, Int64 FKCategoryID, Int64 FKConditionID, Int64 FKLocationID, Int64 FKDeptID, Int64 FKEmpID, Int64 FKRepairPartyID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetLocationTransfer", PageSize, PageNo, SortBy, SortDir, PKID,DateWise,FromDate,ToDate, FKAssetID,AssetCode, FKCategoryID, FKConditionID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);


        }
        #endregion

        #region Masters
        public DataSet GetAssetConditionMaster()
        {
            dbcommand = db.GetStoredProcCommand("uspGetAssetConditionMaster");
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetLocationMaster()
        {
            dbcommand = db.GetStoredProcCommand("uspGetLocationMaster");
            return db.ExecuteDataSet(dbcommand);
        }
        #endregion
    }
}
