using BL.Master;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class Dashboard : System.Web.UI.Page
    {
        public string StrLinks = "";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!ClsLogin.ValidateLogin())
            {
                Response.Redirect("/Users/Logout.aspx");

            }
            else
            {
                if (Convert.ToString(Session["RoleType"]) != "Admin")
                {
                    Response.Redirect("/Users/DashboardUser.aspx");

                }
                StrLinks = ClsLogin.SettingDashboardLinks();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blUser objda = new blUser();
                ClsGeneral objgen = new ClsGeneral();
                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.FKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                objda.RoleType = Convert.ToString(HttpContext.Current.Session["RoleType"]);
                DataSet ds = objda.GetAdminDashboard();

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DashboardGetTopTasks(string daterange)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blUser objda = new blUser();
                ClsGeneral objgen = new ClsGeneral();
                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.FKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                objda.RoleType = Convert.ToString(HttpContext.Current.Session["RoleType"]);
                var dresult = DateRange.getLastDates(daterange, "", "", Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                DataSet ds = objda.DashboardGetTopTasks(dresult.fromdate, dresult.todate);

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetRecentLogs()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blUser objda = new blUser();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserId"]);
                objda.FKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);

                DataSet ds = objda.GetRecentLog();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
    }
}