using BL.Master;
using BL.Schedule;
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
    public partial class RptScheduleReportbyEmployeeClient : System.Web.UI.Page
    {
        public string PageVersion = "13062022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.ScheduleReportbyEmployeeClient, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ScheduleReportbyEmployeeClient).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.ScheduleReportbyEmployeeClient).ToString();
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetScheduleStatusMaster()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blSchedule objda = new blSchedule();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetScheduleStatusMaster();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetWorkTypeMaster()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blSchedule objda = new blSchedule();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetWorkTypeMaster(Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, string daterange, string FromDate, string ToDate, Int64 PKID, string FKEmpID, string FKClientID, string FKProjectID, Int64 FKStatusID, Int64 FKWorkTypeID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ScheduleReportbyClient, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blSchedule objda = new blSchedule();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                DataSet ds = objda.GetClientScheduleDetail(PageSize, OffSet, SortBy, SortDir, dresult.DateWise, dresult.fromdate, dresult.todate, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID, FKClientID, FKProjectID, FKStatusID, FKWorkTypeID,"");
                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }

    }
}