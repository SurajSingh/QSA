using BL.Asset;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class AssetMaster : System.Web.UI.Page
    {
        public string PageVersion = "12042022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.AssetMaster, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.AssetMaster).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.AssetMaster).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }





        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, Int64 PKID, string AssetCode, Int64 FKCategoryID, Int64 FKConditionID, Int64 FKLocationID, Int64 FKDeptID, Int64 FKEmpID, Int64 FKRepairPartyID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.AssetMaster, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetAsset(PageSize, OffSet, SortBy, SortDir, PKID, AssetCode, FKCategoryID, FKConditionID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, string AssetCode, string AssetName, string AssetDesc, Int64 FKCategoryID, string Manufacturer, Int64 FKPartyID, decimal PurchaseRate, decimal CurrentRate, object PurchaseDate, string InvoiceID, string PONo, string Barcode, string SerialNo, string Remarks, string ImgURL, Int64 FKConditionID, Int64 FKLocationID, Int64 FKDeptID, Int64 FKEmpID, Int64 FKRepairPartyID)
        {
            string result = "";
            int status = 1;
            if (AssetCode == "" || AssetName == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.AssetMaster, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                if (Convert.ToString(PurchaseDate) == "")
                {
                    PurchaseDate = null;
                }
                else
                {
                    PurchaseDate = (DateTime.ParseExact(PurchaseDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.AssetMaster;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();

                DataSet dsResult = objda.InsertAsset(PKID, AssetCode, AssetName, AssetDesc, FKCategoryID, Manufacturer, FKPartyID, PurchaseRate, CurrentRate, PurchaseDate, InvoiceID, PONo, Barcode, SerialNo, Remarks, ImgURL, FKConditionID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.AssetMaster, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.AssetMaster;
                DataSet dsResult = objda.DeleteAsset(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}