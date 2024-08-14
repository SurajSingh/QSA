using BL.Master;
using BL.Report;
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
    public partial class RptEmployeeTimesheet : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.TimesheetReport, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.TimesheetReport).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.TimesheetReport).ToString();
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, string daterange, string FromDate, string ToDate, string FKEmpID, string FKClientID, string FKProjectID, Int64 FKManagerID, string  ApproveStatus,string Billed,string Billable)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.TimesheetReport, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blTimesheetReport objda = new blTimesheetReport();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                string ColStr = "[PKID],[TaskDate],[FKTaskID],[FKEmpID],[FKProjectID],[FKClientID],[Hrs],[Description],[IsBillable],[Memo],[TBHours],[TCostRate],[TBillRate],[BillAmt],[CostAmt],[Amount],[BudAmt],[BillHrs],[UnBillHrs],[ApproveStatus],[TaskStatus],[ProjectCode],[ProjectName],[TaskName],[BHours],[TBHours],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[TType]";



                DataSet ds = objda.GetTimeandExpReport(PageSize, OffSet, SortBy, SortDir, ColStr, dresult.DateWise, dresult.fromdate, dresult.todate, 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID, FKClientID, FKProjectID,"", FKManagerID, ApproveStatus, Billed, Billable, "Task");

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }

    }
}