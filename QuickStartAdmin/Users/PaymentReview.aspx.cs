using BL;
using BL.Master;
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
    public partial class PaymentReview : System.Web.UI.Page
    {
        public string PageVersion = "1204202202";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.PaymentReview, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.PaymentReview).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }





        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, string daterange, string FromDate, string ToDate, Int64 PKID, string FKClientID, string PayID, Int64 FKPaymentTypeID, Int64 FKPaymodeID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.PaymentReview, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blBilling objda = new blBilling();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                DataSet ds = objda.GetPayment(PageSize, OffSet, SortBy, SortDir, dresult.DateWise, dresult.fromdate, dresult.todate, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKClientID, PayID, FKPaymentTypeID, FKPaymodeID, "");

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.PaymentReview, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blBilling objda = new blBilling();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.PaymentReview;
                DataSet dsResult = objda.DeletePayment(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}