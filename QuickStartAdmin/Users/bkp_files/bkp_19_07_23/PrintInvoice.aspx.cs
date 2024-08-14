
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

               

                blCompany objcompany = new blCompany();
                objcompany.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);              
                DataSet dsCompany = objcompany.GetCompanyForReport();
                ClsGeneral objgen = new ClsGeneral();

                blBilling objda = new blBilling();
             

                DataSet ds = objda.GetInvoice(0, 0, "", "", false, null, null, Convert.ToInt64(Request.QueryString["PKID"]), Convert.ToInt64(HttpContext.Current.Session["OrgID"]), "","", "", 0, "Print");



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
                    if (Convert.ToString(ds.Tables[0].Rows[0]["ClientCPersonTitle"]) != "") {
                        strCustomerName = strCustomerName + ", " + Convert.ToString(ds.Tables[0].Rows[0]["ClientCPersonTitle"]);
                    }                  
                    strCustomerName = strCustomerName + "<br/>" + Convert.ToString(ds.Tables[0].Rows[0]["ClientName"]);
                    strCustomerAddress = objgen.SetAddress(Convert.ToString(ds.Tables[0].Rows[0]["Address1"]), Convert.ToString(ds.Tables[0].Rows[0]["Address2"]), Convert.ToString(ds.Tables[0].Rows[0]["CountryName"]), Convert.ToString(ds.Tables[0].Rows[0]["StateName"]), Convert.ToString(ds.Tables[0].Rows[0]["CityName"]), Convert.ToString(ds.Tables[0].Rows[0]["TahsilName"]), Convert.ToString(ds.Tables[0].Rows[0]["ZIP"]));

                    ReportParameter[] param = new ReportParameter[7];
                    param[0] = new ReportParameter("CompanyLogo", "file:\\" + AppDomain.CurrentDomain.BaseDirectory + logosmall, true);                  
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

                    string path = "";
                    path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Invoice\\invoice1.rdlc";
                    ReportViewer1.LocalReport.ReportPath = path;
                    ReportViewer1.ProcessingMode = ProcessingMode.Local;
                    ReportViewer1.LocalReport.DataSources.Clear();

                    ReportViewer1.LocalReport.EnableExternalImages = true;

                    ReportViewer1.LocalReport.DataSources.Add(rds1);
                    ReportViewer1.LocalReport.DataSources.Add(rds2);
                    ReportViewer1.LocalReport.DataSources.Add(rds3);
                    ReportViewer1.LocalReport.DataSources.Add(rds4);

                    ReportViewer1.LocalReport.SetParameters(param);
                    ReportViewer1.LocalReport.DisplayName = Convert.ToString(ds.Tables[0].Rows[0]["InvoiceID"]);

                    ReportViewer1.LocalReport.Refresh();
                }

                else
                {
                    Response.Redirect("/Users/BadRequest.aspx");

                }
            }
        }
    }
}