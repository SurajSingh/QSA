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
    public partial class Schedule : System.Web.UI.Page
    {
        public string PageVersion = "13062022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.Schedule, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.Schedule).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.Schedule).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
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
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Schedule, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blSchedule objda = new blSchedule();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                if (!ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Schedule, ClsRoles.IsAdd))
                {
                    FKEmpID = Convert.ToString(HttpContext.Current.Session["UserID"]);
                }


                DataSet ds = objda.GetClientSchedule(PageSize, OffSet, SortBy, SortDir, dresult.DateWise, dresult.fromdate, dresult.todate, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID, FKClientID, FKProjectID, FKStatusID, FKWorkTypeID);

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SendEmail(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Schedule, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                ClsSMSEmail ObjSend = new ClsSMSEmail();
                ObjSend.SendScheduleEmail(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]),"manual", (Int64)ClsPages.SMSEmailLocation.Scheduling, Convert.ToInt64(HttpContext.Current.Session["UserID"]), (Int64)ClsPages.WebPages.Schedule);
                result = @"[{""Result"":""1"",""Msg"":""" + "" + @"""}]";
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, Int64 FKProjectID, object FromDate, object ToDate, object FromTime, Int64 FKWorkTypeID, Int64 FKStatusID, string Remarks, string StrEmp)
        {
            string result = "";
            int status = 1;
            if (FKProjectID == 0 || StrEmp == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Schedule, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                FromDate = (DateTime.ParseExact(FromDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));
                ToDate = (DateTime.ParseExact(ToDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                if (Convert.ToDateTime(FromDate) > Convert.ToDateTime(ToDate))
                {
                    status = 0;
                    result = @"[{""Result"":""0"",""Msg"":""" + "From date is greater then to date" + @"""}]";
                }

            }
            if (status == 1)
            {
                blSchedule objda = new blSchedule();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Schedule;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();


                if (FromTime.ToString() == "")
                {
                    FromTime = null;
                }
                else
                {
                    DateTime dateTime = DateTime.ParseExact(FromTime.ToString(),
                                    "h:mm tt", CultureInfo.InvariantCulture);
                    FromTime = dateTime.TimeOfDay;
                }
                DataSet dsResult = objda.InsertClientSchedule(PKID, FKProjectID, FromDate, ToDate, FromTime, FKWorkTypeID, FKStatusID, Remarks, StrEmp, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Schedule, ClsRoles.IsDelete))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blSchedule objda = new blSchedule();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Schedule;
                DataSet dsResult = objda.DeleteClientSchedule(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string UpdateScheduleStatus(Int64 PKID, Int64 FKStatusID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Schedule, ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blSchedule objda = new blSchedule();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Schedule;
                DataSet dsResult = objda.UpdateScheduleStatus(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKStatusID);
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}