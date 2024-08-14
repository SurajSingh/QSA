using BL;
using BL.Master;
using BL.Report;
using BLGeneral;
using Microsoft.Reporting.WebForms;
using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users.Reports
{
    public partial class BillingReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!ClsLogin.ValidateLogin())
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>LogoutParent();alert('Session Out!');</script>", false);
                return;
            }
            if (!Page.IsPostBack)
            {
                //FillReport();

            }

        }

        protected void btnViewReport_Click(object sender, EventArgs e)
        {


            FillReport();


        }
        public void FillReport()
        {
            blTimesheetReport objda = new blTimesheetReport();
            ClsGeneral objgen = new ClsGeneral();
            blCompany objcompany = new blCompany();
            DataSet ds = new DataSet();
            string strAddress = "";
            string strcontact = "";
            string StrReportName = "Report";
            string path = "";
            string ColStr = "";

            if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.ApprovedTimeandExpenseswithMemos)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\BillingReport\\ApprovedTimeandExpenseswithMemos.rdlc";

                StrReportName = "ApprovedTimeandExpenseswithMemos";
                ColStr = "[PKID],[TaskDate],[FKTaskID],[FKEmpID],[FKProjectID],[FKClientID],[Hrs],[Description],[IsBillable],[Memo],[TBHours],[TCostRate],[TBillRate],[BillAmt],[CostAmt],	[BudAmt],[BillHrs],[Amount],[UnBillHrs],[ApproveStatus],[TaskStatus],[ProjectCode],[ProjectName],[TaskName],[BHours],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[TType]";
            }
           else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.InvoiceRegister)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\BillingReport\\InvoiceRegister.rdlc";

                StrReportName = "InvoiceRegister";
           
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.InvoiceRegisterwithCosts)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\BillingReport\\InvoiceRegisterwithCosts.rdlc";

                StrReportName = "InvoiceRegisterwithCosts";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.InvoiceRegisterbyClient)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ClientReport\\InvoiceRegisterbyClient.rdlc";

                StrReportName = "InvoiceRegisterbyClient";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.MonthlyBillingSummarybyClient)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ClientReport\\MonthlyBillingSummarybyClient.rdlc";

                StrReportName = "InvoiceRegisterbyClient";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.BillingStatementbyClient)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\BillingReport\\BillingStatementbyClient.rdlc";

                StrReportName = "BillingStatementbyClient";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.BillingStatementbyProject)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\BillingReport\\BillingStatementbyProject.rdlc";

                StrReportName = "BillingStatementbyProject";

            }

            var dresult = DateRange.getLastDates(HidDateRange.Value, HidFromDate.Value, HidToDate.Value, Convert.ToString(HttpContext.Current.Session["DateFormat"]));
            if(Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.InvoiceRegisterbyClient || Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.MonthlyBillingSummarybyClient || Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.InvoiceRegister || Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.InvoiceRegisterwithCosts || Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.BillingStatementbyClient || Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.BillingStatementbyProject)
            {

                blBilling objda1 = new blBilling();
                ds = objda1.GetInvoice(0, 0, "", "", dresult.DateWise, dresult.fromdate, dresult.todate, 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), HidClient.Value, HidProject.Value, HidRecType.Value, 0, "");

            }
            else
            {
                ds = objda.GetTimeandExpReport(0, 0, "ProjectCode", "", ColStr, dresult.DateWise, dresult.fromdate, dresult.todate, 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), HidEmpID.Value, HidClient.Value, HidProject.Value, "", Convert.ToInt64(HidFKManagerIDSrch.Value), HidApproved.Value, HidBilledSrch.Value, HidBillable.Value, HidRecType.Value);

            }




            objcompany.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
            DataSet dsCompany = objcompany.GetCompanyForReport();




            strAddress = objgen.SetAddress(Convert.ToString(dsCompany.Tables[0].Rows[0]["Address1"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Address2"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["CountryName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["StateName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["CityName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["TahsilName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["ZIP"]));
            strcontact = objgen.SetContactDetail(Convert.ToString(dsCompany.Tables[0].Rows[0]["Phone"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Fax"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Email"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Website"]));

            ReportParameter[] param = new ReportParameter[4];
            param[0] = new ReportParameter("companyname", Convert.ToString(dsCompany.Tables[0].Rows[0]["CompanyName"]), true);
            param[1] = new ReportParameter("companyaddress", strAddress, true);
            param[2] = new ReportParameter("companyphone", strcontact, true);
            param[3] = new ReportParameter("reportfilter", dresult.datetext, true);


            ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);



            ReportViewer1.LocalReport.ReportPath = path;
            ReportViewer1.ProcessingMode = ProcessingMode.Local;
            ReportViewer1.LocalReport.DataSources.Clear();

            ReportViewer1.LocalReport.EnableExternalImages = true;

            ReportViewer1.LocalReport.DataSources.Add(rds1);
            ReportViewer1.LocalReport.SetParameters(param);
            ReportViewer1.LocalReport.DisplayName = StrReportName;

            ReportViewer1.LocalReport.Refresh();


        }
    }
}