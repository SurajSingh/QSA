
using BL.Master;
using QuickStartAdmin.Classes;
using iTextSharp.text.pdf;
using Microsoft.Reporting.WebForms;
using System;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.UI;
using BL;
using BLGeneral;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class PrintInvoice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!ClsLogin.ValidateLogin())
            {
                Response.Redirect("/Users/Logout.aspx");
            }



            if (!Page.IsPostBack)
            {
                if (Request.QueryString["PKID"] == null)
                {
                    Response.Redirect("/Users/Dashboard.aspx");
                }

                ReportViewer1.ProcessingMode = ProcessingMode.Local;
                ReportViewer1.SizeToReportContent = true;
                ReportViewer1.Width = Unit.Percentage(100);
                ReportViewer1.Height = Unit.Percentage(100);



                blCompany objcompany = new blCompany();
                objcompany.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                DataSet dsCompany = objcompany.GetCompanyForReport();
                ClsGeneral objgen = new ClsGeneral();

                blBilling objda = new blBilling();

                int templateId = Convert.ToInt32(dsCompany.Tables[0].Rows[0]["InvoiceTempID"]);

                DataSet ds = objda.GetInvoice(0, 0, "", "", false, null, null, Convert.ToInt64(Request.QueryString["PKID"]), Convert.ToInt64(HttpContext.Current.Session["OrgID"]), "", "", "", 0, "Print");



                if (ds.Tables[0].Rows.Count > 0)
                {
                    string logosmall = "";
                    if (dsCompany.Tables[0].Rows[0]["SmallLogoURL"].ToString() == "")
                    {
                        logosmall = "Users\\images\\nologo.png";

                    }
                    else
                    {
                        logosmall = "Users\\UserFiles\\Logo\\" + dsCompany.Tables[0].Rows[0]["SmallLogoURL"].ToString();

                    }

                    string strAddress = "";
                    string strcontact = "";
                    string strCustomerName = "";
                    string strCustomerAddress = "";
                    strAddress = objgen.SetAddress(Convert.ToString(dsCompany.Tables[0].Rows[0]["Address1"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Address2"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["CountryName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["StateName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["CityName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["TahsilName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["ZIP"]));
                    strcontact = objgen.SetContactDetail(Convert.ToString(dsCompany.Tables[0].Rows[0]["Phone"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Fax"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Email"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Website"]));
                    strCustomerName = Convert.ToString(ds.Tables[0].Rows[0]["ClientCPerson"]);
                    if (Convert.ToString(ds.Tables[0].Rows[0]["ClientCPersonTitle"]) != "")
                    {
                        strCustomerName = strCustomerName + ", " + Convert.ToString(ds.Tables[0].Rows[0]["ClientCPersonTitle"]);
                    }
                    strCustomerName = strCustomerName + "<br/>" + Convert.ToString(ds.Tables[0].Rows[0]["ClientName"]);
                    strCustomerAddress = objgen.SetAddress(Convert.ToString(ds.Tables[0].Rows[0]["Address1"]), Convert.ToString(ds.Tables[0].Rows[0]["Address2"]), Convert.ToString(ds.Tables[0].Rows[0]["CountryName"]), Convert.ToString(ds.Tables[0].Rows[0]["StateName"]), Convert.ToString(ds.Tables[0].Rows[0]["CityName"]), Convert.ToString(ds.Tables[0].Rows[0]["TahsilName"]), Convert.ToString(ds.Tables[0].Rows[0]["ZIP"]));

                    ReportParameter[] param = new ReportParameter[7];

                    string imagePath = "file:///" + AppDomain.CurrentDomain.BaseDirectory + logosmall;

                    param[0] = new ReportParameter("CompanyLogo", imagePath, true);
                    param[1] = new ReportParameter("CompanyName", Convert.ToString(dsCompany.Tables[0].Rows[0]["CompanyName"]), true);


                    param[2] = new ReportParameter("CompanyAddress", strAddress, true);




                    param[3] = new ReportParameter("CompanyContactDetail", strcontact, true);
                    param[4] = new ReportParameter("CurrencySymbol", Convert.ToString(ds.Tables[0].Rows[0]["Symbol"]), true);
                    param[5] = new ReportParameter("CustomerName", strCustomerName, true);
                    param[6] = new ReportParameter("CustomerAddress", strCustomerAddress, true);



                    ReportDataSource rds1 = new ReportDataSource("DataSet1", ds.Tables[0]);
                    ReportDataSource rds2 = new ReportDataSource("DataSet2", ds.Tables[1]);
                    ReportDataSource rds3 = new ReportDataSource("DataSet3", ds.Tables[2]);
                    ReportDataSource rds4 = new ReportDataSource("DataSet4", ds.Tables[3]);
                    ReportDataSource rds5 = new ReportDataSource("DataSet5", ds.Tables[4]);//Added by Nilesh to show Expense Amount

                    string displayName = Convert.ToString(ds.Tables[0].Rows[0]["InvoiceID"]);
                    string reportPath = string.Empty;
                    if (templateId == 1)
                        reportPath = "\\Users\\RDLC\\DesignFiles\\Invoice\\invoice1.rdlc";
                    else if (templateId == 2)
                        reportPath = "\\Users\\RDLC\\DesignFiles\\Invoice\\invoice2.rdlc";
                    else if (templateId == 3)
                        reportPath = "\\Users\\RDLC\\DesignFiles\\Invoice\\invoice3.rdlc";
                    PrintReportTemplate(reportPath, param, displayName, rds1, rds2, rds3, rds4, rds5); 
                }

                else
                {
                    Response.Redirect("/Users/BadRequest.aspx");

                }
            }
        }

        private void PrintReportTemplate(string reportPath, ReportParameter[] param, string displayName, ReportDataSource rds1, ReportDataSource rds2, ReportDataSource rds3, ReportDataSource rds4, ReportDataSource rds5)
        {
            string path = "";
            path = AppDomain.CurrentDomain.BaseDirectory + reportPath;//
            ReportViewer1.LocalReport.ReportPath = path;
            ReportViewer1.ProcessingMode = ProcessingMode.Local;
            ReportViewer1.LocalReport.DataSources.Clear();

            ReportViewer1.LocalReport.EnableExternalImages = true;

            ReportViewer1.LocalReport.DataSources.Add(rds1);
            ReportViewer1.LocalReport.DataSources.Add(rds2);
            ReportViewer1.LocalReport.DataSources.Add(rds3);
            ReportViewer1.LocalReport.DataSources.Add(rds4);
            ReportViewer1.LocalReport.DataSources.Add(rds5); //Added by Nilesh to show Expense Amount

            ReportViewer1.LocalReport.SetParameters(param);
            ReportViewer1.LocalReport.DisplayName = displayName;
            //
            ReportViewer1.LocalReport.Refresh();
        }
    }
}