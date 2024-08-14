using BL.Appointment;
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
    public partial class ViewAppointments : System.Web.UI.Page
    {
        public string PageVersion = "22062022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.ViewAppointments, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ViewAppointments).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }





        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, string daterange, string FromDate, string ToDate, Int64 PKID, string FKEmpID, string ApproveStatus)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ViewAppointments, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blAppointment objda = new blAppointment();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                if (!ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ViewAppointmentsOthers, ClsRoles.IsView))
                {
                    FKEmpID = Convert.ToString(HttpContext.Current.Session["UserID"]);
                }
                DataSet ds = objda.GetAppointment(PageSize, OffSet, SortBy, SortDir, dresult.DateWise, dresult.fromdate, dresult.todate, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID, 0, ApproveStatus);

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, Int64 FKEmpID, Int64 FKIntervalID, object OnDate, object FromTime, object ToTime, string CutomerName, string CompanyName, string EmailID, string Mobile, string Remarks, string ApproveStatus)
        {
            string result = "";
            int status = 1;
            DateTime FromTime1;
            DateTime ToTime1;
            if (FKIntervalID == 0 || OnDate.ToString() == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ViewAppointments, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            string[] formats = { "h:mm tt" };
            if (status == 1)
            {
                if (!DateTime.TryParseExact(FromTime.ToString(), formats, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out FromTime1))
                {
                    status = 0;
                    result = @"[{""Result"":""0"",""Msg"":""" + "Invalid from time" + @"""}]";
                }
            }
            if (status == 1)
            {
                if (!DateTime.TryParseExact(ToTime.ToString(), formats, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out ToTime1))
                {
                    status = 0;
                    result = @"[{""Result"":""0"",""Msg"":""" + "Invalid to time" + @"""}]";
                }
            }
            if (status == 1)
            {
                FromTime1 = DateTime.ParseExact(FromTime.ToString(), "h:mm tt", CultureInfo.InvariantCulture);
                ToTime1 = DateTime.ParseExact(ToTime.ToString(), "h:mm tt", CultureInfo.InvariantCulture);
                if (Convert.ToDateTime(FromTime1) > Convert.ToDateTime(ToTime1))
                {
                    status = 0;
                    result = @"[{""Result"":""0"",""Msg"":""" + "From time is greater then to time" + @"""}]";
                }
                else if (Convert.ToDateTime(FromTime1) == Convert.ToDateTime(ToTime1))
                {
                    status = 0;
                    result = @"[{""Result"":""0"",""Msg"":""" + "From time is and to time is same" + @"""}]";
                }


                if (status == 1)
                {
                    FromTime = FromTime1.TimeOfDay;
                    ToTime = ToTime1.TimeOfDay;
                }



            }
            if (status == 1)
            {
                blAppointment objda = new blAppointment();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ViewAppointments;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();

                OnDate = (DateTime.ParseExact(OnDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));


                DataSet dsResult = objda.InsertAppointment(PKID, FKEmpID, FKIntervalID, OnDate, FromTime, ToTime, CutomerName, CompanyName, EmailID, Mobile, Remarks, ApproveStatus, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

                if (dsResult.Tables[0].Rows.Count > 0 && Convert.ToInt64(dsResult.Tables[0].Rows[0]["Result"]) == 1 && Convert.ToString(dsResult.Tables[0].Rows[0]["ApproveStatus"]) == "Confirmed")
                {
                    ClsSMSEmail ObjSend = new ClsSMSEmail();
                    string msg = ObjSend.SendAppointmentEmail(Convert.ToInt64(dsResult.Tables[0].Rows[0]["PKID"]), Convert.ToInt64(HttpContext.Current.Session["OrgID"]), "new", (Int64)ClsPages.SMSEmailLocation.Appointment, Convert.ToInt64(HttpContext.Current.Session["UserID"]), (Int64)ClsPages.WebPages.Appointments);
                    if (msg != "1")
                    {
                        result = @"[{""Result"":""0"",""Msg"":""" + msg + @"""}]";
                    }

                }

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ViewAppointments, ClsRoles.IsDelete))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blAppointment objda = new blAppointment();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ViewAppointments;
                DataSet dsResult = objda.DeleteAppointment(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);



            }

            return result;

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetAppointmentAvailability(object OnDate, Int64 FKEmpID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ScheduleAvailability, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blAppointment objda = new blAppointment();
                ClsGeneral objgen = new ClsGeneral();
                OnDate = (DateTime.ParseExact(OnDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                DataSet ds = objda.GetAppointmentAvailability(true, OnDate, OnDate, 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID, "Available");

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string UpdateAppointmentsStatus(Int64 PKID, string FKStatusID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ViewAppointments, ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blAppointment objda = new blAppointment();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ViewAppointments;
                DataSet dsResult = objda.UpdateAppointmentStatus(Convert.ToInt64(HttpContext.Current.Session["OrgID"]), PKID, FKStatusID);
                result = objgen.SerializeToJSON(dsResult.Tables[0]);
                if (dsResult.Tables[0].Rows.Count > 0 && Convert.ToInt64(dsResult.Tables[0].Rows[0]["Result"]) == 1 && (FKStatusID == "Confirmed" || FKStatusID == "Cancelled"))
                {
                    ClsSMSEmail ObjSend = new ClsSMSEmail();
                    result = ObjSend.SendAppointmentEmail(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), "new", (Int64)ClsPages.SMSEmailLocation.Appointment, Convert.ToInt64(HttpContext.Current.Session["UserID"]), (Int64)ClsPages.WebPages.Appointments);

                }
            }

            return result;

        }
    }
}