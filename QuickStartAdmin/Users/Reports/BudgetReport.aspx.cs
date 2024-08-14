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
    public partial class BudgetReport : System.Web.UI.Page
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
            blBudgetReport objda = new blBudgetReport();
            ClsGeneral objgen = new ClsGeneral();
            blCompany objcompany = new blCompany();
            DataSet ds = new DataSet();
            string strAddress = "";
            string strcontact = "";
            string StrReportName = "Report";
            string path = "";
            

            if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.BudgetSummaryReport)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\BudgetReport\\BudgetSummaryReport.rdlc";

                StrReportName = "BudgetSummaryReport";
              
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.BudgetDetailbyProjectEmployee)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\BudgetReport\\BudgetDetailbyProjectEmployee.rdlc";

                StrReportName = "BudgetSummaryReport";

            }


            var dresult = DateRange.getLastDates(HidDateRange.Value, HidFromDate.Value, HidToDate.Value, Convert.ToString(HttpContext.Current.Session["DateFormat"]));
            if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.BudgetSummaryReport)
            {
                ds = objda.GetBudgetReport(0, 0, "BudgetTitle", "", dresult.DateWise, dresult.fromdate, dresult.todate, 0, HidProject.Value, HidClient.Value, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));


            }
            else
            {
                ds = objda.GetBudgetDetailReport(0, 0, "BudgetTitle", "", dresult.DateWise, dresult.fromdate, dresult.todate, 0, HidProject.Value, HidClient.Value, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

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