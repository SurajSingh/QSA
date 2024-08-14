using BL;
using BL.Master;
using BL.Payroll;
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
    public partial class IssueLeave : System.Web.UI.Page
    {
        public string PageVersion = "17052022";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.IssueLeave, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.IssueLeave).ToString();
            }

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetPayrollSetting()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetPayrollSetting(0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetEmpLeaveReport(Int64 FKEmpID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetEmpLeaveReport(Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID, 0);
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string CalculateEmployeeLeave(Int64 FKEmpID,Int64 FKLeaveID, object FormDate, decimal NoOfDays)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();
                FormDate = (DateTime.ParseExact(FormDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                DataSet ds = objda.CalculateEmployeeLeave(FKLeaveID, FKEmpID, FormDate, NoOfDays, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, string daterange, string FromDate, string ToDate, Int64 PKID,Int64 FKEmpID, Int64 FKLeaveID, string LeaveType, string ApproveStatus)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.IssueLeave, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                DataSet ds = objda.GetLeaveRequest(PageSize, OffSet, SortBy, SortDir, dresult.DateWise, dresult.fromdate, dresult.todate, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]),FKEmpID, FKLeaveID, LeaveType, ApproveStatus);

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, object FromDate, object ToDate,Int64 FKEmpID, Int64 FKLeaveID, decimal LeaveCount, string Remarks)
        {
            string result = "";
            int status = 1;

            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.IssueLeave, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.IssueLeave;
                FromDate = (DateTime.ParseExact(FromDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));
                ToDate = (DateTime.ParseExact(ToDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                DataSet dsResult = objda.InsertLeaveRequest(PKID, FromDate, ToDate, FKEmpID, FKLeaveID, LeaveCount, Remarks, "Approved", 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);
                if (dsResult.Tables[0].Rows.Count > 0 && Convert.ToInt64(dsResult.Tables[0].Rows[0]["Result"]) == 1)
                {
                    ClsSMSEmail ObjSend = new ClsSMSEmail();
                    ObjSend.SendLeaveEmail(Convert.ToInt64(dsResult.Tables[0].Rows[0]["PKID"]), Convert.ToInt64(HttpContext.Current.Session["OrgID"]), "issue", (Int64)ClsPages.SMSEmailLocation.LeaveRequest, Convert.ToInt64(HttpContext.Current.Session["UserID"]), (Int64)ClsPages.WebPages.Schedule);

                }


            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.IssueLeave, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.IssueLeave;
                DataSet dsResult = objda.DeleteLeaveRequest(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}