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
    public partial class AnalysisReport : System.Web.UI.Page
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
            string SortBy = "ProjectCode";
            string ColStr = "[LoginID],[EmpName],[Hrs],[TBHours],[BillAmt],[CostAmt],[BudAmt]";

            if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.AHoursBHoursComparisonbyEmployee)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\Analysis\\AHoursBHoursComparisonbyEmployee.rdlc";

                StrReportName = "AHoursBHoursComparisonbyEmployee";
                ColStr = "[LoginID],[EmpName],[Hrs],[TBHours],[BillAmt],[CostAmt],[BudAmt]";
                SortBy = "LoginID";
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.AHoursBHoursComparisonbyProject)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\Analysis\\AHoursBHoursComparisonbyProject.rdlc";

                StrReportName = "AHoursBHoursComparisonbyProject";
                ColStr = "[ProjectCode],[ProjectName],[Hrs],[TBHours],[BillAmt],[CostAmt],[BudAmt],[PBudgetedHours],[ServiceAmt]";
            }
           

            var dresult = DateRange.getLastDates(HidDateRange.Value, HidFromDate.Value, HidToDate.Value, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

            ds = objda.GetTimesheetReport(0, 0, SortBy, "", ColStr, dresult.DateWise, dresult.fromdate, dresult.todate, 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), HidEmpID.Value, HidClient.Value, HidProject.Value, "", HidApproved.Value, "", HidBillable.Value, "");




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