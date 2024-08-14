using BL.Master;
using BL.Payroll;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Data;
using System.Globalization;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class HolidayCalendar : System.Web.UI.Page
    {
        public string PageVersion = "07032022";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.HolidayCalendar, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.HolidayCalendar).ToString();
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.HolidayCalendar, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();


                DataSet ds = objda.GetHoliday(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID,object HolidayDate, string Name, string Desc)
        {
            string result = "";
            int status = 1;
            if (Name == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.HolidayCalendar, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();
                HolidayDate = (DateTime.ParseExact(HolidayDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));
                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.HolidayCalendar;
                DataSet dsResult = objda.InsertHoliday(PKID, HolidayDate,Name, Desc, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.HolidayCalendar, ClsRoles.IsDelete))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();


                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.HolidayCalendar;
                DataSet dsResult = objda.DeleteHoliday(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}