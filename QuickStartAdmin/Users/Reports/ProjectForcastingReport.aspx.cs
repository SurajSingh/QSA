using BL.Asset;
using BL.Master;
using BL.ProjectManagement;
using BLGeneral;
using Microsoft.Reporting.WebForms;
using QuickStartAdmin.Classes;
using System;
using System.Data;
using System.Web;
using System.Web.UI;


namespace QuickStartAdmin.Users.Reports
{
    public partial class ProjectForcastingReport : System.Web.UI.Page
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
            blProjectManagement objda = new blProjectManagement();
            ClsGeneral objgen = new ClsGeneral();
            blCompany objcompany = new blCompany();
            DataSet ds = new DataSet();
            string strAddress = "";
            string strcontact = "";
            string StrReportName = "Report";
            string path = "";


            if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.ProjectForecastingReport)
            {
                StrReportName = "ProjectForecastingReport";
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ProjectReport\\ProjectForecastingReport.rdlc";
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.ProjectAllocationReport)
            {
                StrReportName = "ProjectForecastingReport";
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ProjectReport\\ProjectAllocationReport.rdlc";
            }

            ds = objda.GetProjectForcastingReport(Convert.ToInt64(txtFKProjectID.Value),Convert.ToInt64(HttpContext.Current.Session["OrgID"]), txtRecType.Value);




            objcompany.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
            DataSet dsCompany = objcompany.GetCompanyForReport();




            strAddress = objgen.SetAddress(Convert.ToString(dsCompany.Tables[0].Rows[0]["Address1"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Address2"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["CountryName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["StateName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["CityName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["TahsilName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["ZIP"]));
            strcontact = objgen.SetContactDetail(Convert.ToString(dsCompany.Tables[0].Rows[0]["Phone"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Fax"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Email"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Website"]));

            ReportParameter[] param = new ReportParameter[3];
            param[0] = new ReportParameter("companyname", Convert.ToString(dsCompany.Tables[0].Rows[0]["CompanyName"]), true);
            param[1] = new ReportParameter("companyaddress", strAddress, true);
            param[2] = new ReportParameter("companyphone", strcontact, true);



            ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);
            ReportDataSource rds2 = new ReportDataSource("DataSet2", ds.Tables[1]);


            ReportViewer1.LocalReport.ReportPath = path;
            ReportViewer1.ProcessingMode = ProcessingMode.Local;
            ReportViewer1.LocalReport.DataSources.Clear();

            ReportViewer1.LocalReport.EnableExternalImages = true;

            ReportViewer1.LocalReport.DataSources.Add(rds1);
            ReportViewer1.LocalReport.DataSources.Add(rds2);
            ReportViewer1.LocalReport.SetParameters(param);
            ReportViewer1.LocalReport.DisplayName = StrReportName;

            ReportViewer1.LocalReport.Refresh();


        }
    }
}