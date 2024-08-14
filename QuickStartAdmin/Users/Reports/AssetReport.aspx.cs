using BL.Asset;
using BL.Master;
using BLGeneral;
using Microsoft.Reporting.WebForms;
using QuickStartAdmin.Classes;
using System;
using System.Data;
using System.Web;
using System.Web.UI;

namespace QuickStartAdmin.Users.Reports
{
    public partial class AssetReport : System.Web.UI.Page
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
            blAsset objda = new blAsset();
            ClsGeneral objgen = new ClsGeneral();
            blCompany objcompany = new blCompany();
            DataSet ds = new DataSet();
            string strAddress = "";
            string strcontact = "";
            string StrReportName = "Report";
            string path = "";
            
           
            if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.AssetReportByDepartment)
            {
                StrReportName = "AssetReportByDepartment";
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\AssetReport\\AssetReportByDepartment.rdlc";
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.AssetReportByEmployee)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\AssetReport\\AssetReportByEmployee.rdlc";
                StrReportName = "AssetReportByEmployee";
               
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.AssetReportByLocation)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\AssetReport\\AssetReportByLocation.rdlc";
                StrReportName = "AssetReportByLocation";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.AssetReportByCondition)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\AssetReport\\AssetReportByCondition.rdlc";
                StrReportName = "AssetReportByCondition";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.AssetReportByCategory)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\AssetReport\\AssetReportByCategory.rdlc";
                StrReportName = "AssetReportByLocation";

            }


            ds = objda.GetAsset(0, 0, "AssetName", "", 0, HidAssetName.Value, Convert.ToInt64(HidFKCategoryID.Value), Convert.ToInt64(HidFKConditionID.Value), Convert.ToInt64(HidFKLocationID.Value), Convert.ToInt64(HidFKDeptID.Value), Convert.ToInt64(HidFKEmpID.Value), 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));


            objcompany.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
            DataSet dsCompany = objcompany.GetCompanyForReport();




            strAddress = objgen.SetAddress(Convert.ToString(dsCompany.Tables[0].Rows[0]["Address1"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Address2"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["CountryName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["StateName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["CityName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["TahsilName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["ZIP"]));
            strcontact = objgen.SetContactDetail(Convert.ToString(dsCompany.Tables[0].Rows[0]["Phone"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Fax"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Email"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Website"]));

            ReportParameter[] param = new ReportParameter[3];
            param[0] = new ReportParameter("companyname", Convert.ToString(dsCompany.Tables[0].Rows[0]["CompanyName"]), true);
            param[1] = new ReportParameter("companyaddress", strAddress, true);
            param[2] = new ReportParameter("companyphone", strcontact, true);
          


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