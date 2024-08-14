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
    public partial class TransferAsset : System.Web.UI.Page
    {
        public string PageVersion = "12042022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.TransferAsset, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.TransferAsset).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.TransferAsset).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }





        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, Int64 PKID, string daterange, string FromDate, string ToDate, string AssetCode, Int64 FKCategoryID, Int64 FKConditionID, Int64 FKLocationID, Int64 FKDeptID, Int64 FKEmpID, Int64 FKRepairPartyID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.TransferAsset, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                DataSet ds = objda.GetLocationTransfer(PageSize, OffSet, SortBy, SortDir, PKID, dresult.DateWise,dresult.fromdate,dresult.todate,0, AssetCode, FKCategoryID, FKConditionID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, object PurchaseDate, Int64 FKLocationID, Int64 FKDeptID, Int64 FKEmpID, Int64 FKRepairPartyID,string Remarks)
        {
            string result = "";
            int status = 1;
            if (PKID == 0 || FKLocationID==0)
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.TransferAsset, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
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
                objda.FKPageID = (Int64)ClsPages.WebPages.TransferAsset;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();

                DataSet dsResult = objda.InsertLocationTransfer(0, PurchaseDate,PKID, FKLocationID, FKDeptID, FKEmpID, FKRepairPartyID,Remarks, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.TransferAsset, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.TransferAsset;
                DataSet dsResult = objda.DeleteLocationTransfer(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}