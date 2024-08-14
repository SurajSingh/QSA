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
    public partial class ApproveLeaveRequest : System.Web.UI.Page
    {
        public string PageVersion = "19092022";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.ApproveLeaveRequest, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ApproveLeaveRequest).ToString();
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
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, string daterange, string FromDate, string ToDate, Int64 PKID, Int64 FKEmpID, Int64 FKLeaveID, string LeaveType, string ApproveStatus)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ApproveLeaveRequest, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                DataSet ds = objda.GetLeaveRequest(PageSize, OffSet, SortBy, SortDir, dresult.DateWise, dresult.fromdate, dresult.todate, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID, FKLeaveID, LeaveType, ApproveStatus);

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string ApproveEmpLeaveRequest(Int64 PKID,string ApproveStatus, string Remarks)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ApproveLeaveRequest, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ApproveLeaveRequest;
                DataSet dsResult = objda.ApproveLeaveRequest(PKID,ApproveStatus,Remarks, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                if (dsResult.Tables[0].Rows.Count > 0 && Convert.ToInt64(dsResult.Tables[0].Rows[0]["Result"]) == 1)
                {
                    ClsSMSEmail ObjSend = new ClsSMSEmail();
                    ObjSend.SendLeaveEmail(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), "approve", (Int64)ClsPages.SMSEmailLocation.LeaveRequest, Convert.ToInt64(HttpContext.Current.Session["UserID"]), (Int64)ClsPages.WebPages.Schedule);

                }
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ApproveLeaveRequest, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ApproveLeaveRequest;
                DataSet dsResult = objda.DeleteLeaveRequest(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}