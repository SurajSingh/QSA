using BL.Classes.Billing;
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
    public partial class Projects : System.Web.UI.Page
    {

        public string PageVersion = "15082022";
        public string StrCurrency = "$";

        private const int CT_FIXED = 1;
        private const int CT_HOURLY = 2;
        private const int CT_HNTE = 3;
        private const int CT_PERCENTAGE = 4;
        private const int CT_RECURRING = 5;
        private const int CT_RWC = 6;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.Projects, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.Projects).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.Projects).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, Int64 PKID, string ProjectName, Int64 FKClientID, string ActiveStatus, Int64 FKContractTypeID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Projects, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetProject(PageSize, OffSet, SortBy, SortDir, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), ProjectName,FKClientID ,ActiveStatus, FKContractTypeID);

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, Int64 FKClientID, string ProjectCode, string ProjectName, Int64 FKManagerID, Int64 FKContractTypeID, string ProjectStatus, decimal ContractAmt, decimal ExpAmt, decimal ServiceAmt, decimal BudgetedHours, object Startdate, object DueDate, decimal CompletePercent, string PONo, string Remark, Int64 FKCurrencyID, bool ISCustomInvoice, string InvoicePrefix, string InvoiceSuffix, Int64 InvoiceSNo, Int64 FKBillingFrequency,
            decimal GRT, decimal ExpenseTax, Int64 FKTaxID, Int64 FKTermID, bool TBillable, bool TMemoRequired, bool EBillable, bool EMemoRequired, bool TDesReadonly, bool EDesReadOnly, decimal ReccuringAmt)
        {
            string result = "";
            int status = 1;
            if (ProjectCode == "" || ProjectName == "" || ProjectStatus == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Projects, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            //conditional validation based on contract type 
            if (status == 1)
            {
                switch (FKContractTypeID) 
                {
                    case CT_FIXED:
                        if (ContractAmt == 0 || ServiceAmt == 0)
                        {
                            status = 0;
                            result = ClsLogin.GetErrorMsg("V");
                        }
                        break;
                    case CT_HOURLY:
                        //Nothing to validate
                        break;
                    case CT_HNTE:
                        if (BudgetedHours == 0)
                        {
                            status = 0;
                            result = ClsLogin.GetErrorMsg("V");
                        }
                        break;
                    case CT_PERCENTAGE:
                        if (ContractAmt == 0 || ServiceAmt == 0)
                        {
                            status = 0;
                            result = ClsLogin.GetErrorMsg("V");
                        }
                        break;
                    case CT_RECURRING:
                        if (ReccuringAmt == 0 || FKBillingFrequency == 0)
                        {
                            status = 0;
                            result = ClsLogin.GetErrorMsg("V");
                        }
                        break;
                    case CT_RWC:
                        if (ContractAmt == 0 || ServiceAmt == 0 || ReccuringAmt == 0 || FKBillingFrequency == 0)
                        {
                            status = 0;
                            result = ClsLogin.GetErrorMsg("V");
                        }
                        break;
                }
            }
            if (status == 1)
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();

                if (Convert.ToString(Startdate) == "")
                {
                    Startdate = null;
                }
                else
                {
                    Startdate = (DateTime.ParseExact(Startdate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }
                if (Convert.ToString(DueDate) == "")
                {
                    DueDate = null;
                }
                else
                {
                    DueDate = (DateTime.ParseExact(DueDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Projects;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();

                DataSet dsResult = objda.InsertProject(PKID, FKClientID, ProjectCode.Trim(), ProjectName.Trim(), FKManagerID, FKContractTypeID, ProjectStatus, ContractAmt, ExpAmt, ServiceAmt, BudgetedHours, Startdate, DueDate, CompletePercent, PONo, Remark.Trim(), FKCurrencyID, ISCustomInvoice, InvoicePrefix.Trim(), InvoiceSuffix.Trim(), InvoiceSNo, FKBillingFrequency, GRT, ExpenseTax, FKTaxID, FKTermID, TBillable, TMemoRequired, EBillable, EMemoRequired, TDesReadonly, EDesReadOnly, ReccuringAmt, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

                //schedule project billing cycle - Hangfire
                var billingService = new ProjectBillingService();
                if (FKBillingFrequency > 0 && (ProjectStatus.Trim().ToLower() == "active" || ProjectStatus.Trim().ToLower() == "completed"))
                {
                    if (PKID == 0)
                    {
                        PKID = Convert.ToInt32(dsResult.Tables[0].Rows[0]["PKID"]);
                    }

                    //enqueue first invoice generation notification to the project manager based on the billing frequency                    
                    billingService.ScheduleNextBillNotification((int)PKID, (int)FKBillingFrequency);
                }
                else
                {
                    string JobId = billingService.GenerateUniqueJobId(PKID);
                    billingService.StopScheduledJob(JobId);
                }
            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Projects, ClsRoles.IsDelete))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Projects;
                DataSet dsResult = objda.DeleteProject(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

                var billingService = new ProjectBillingService();
                string JobId = billingService.GenerateUniqueJobId(PKID);
                billingService.StopScheduledJob(JobId);
            }

            return result;

        }
    }
}