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
    public partial class EmployeeAndTimeReport : System.Web.UI.Page
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
            string RecType = "";
            string SortBy = "ProjectCode";
            string ColStr = "[LoginID],[EmpName],[Hrs],[TBHours],[BillAmt],[CostAmt],[BudAmt]";

            if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.BilledTimeandExpensesDetailbyProjectEmplo)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\BillingReport\\BilledTimeandExpensesDetailbyProjectEmplo.rdlc";

                StrReportName = "Billed Time and Expenses Detail by Project And Employee";
                ColStr = "[PKID],[TaskDate],[FKTaskID],[FKEmpID],[FKProjectID],[FKClientID],[Hrs],[Description],[IsBillable],[Memo],[TBHours],[TCostRate],[TBillRate],[BillAmt],[CostAmt],[BudAmt],[BillHrs],[UnBillHrs],[ApproveStatus],[TaskStatus],[ProjectCode],[ProjectName],[TaskName],[BHours],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[TType]";
            }
           else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.UnBilledTimeandExpensesDetailbyProjectEm)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\BillingReport\\BilledTimeandExpensesDetailbyProjectEmplo.rdlc";

                StrReportName = "Un-Billed Time and Expenses Detail by Project And Employee";
                ColStr = "[PKID],[TaskDate],[FKTaskID],[FKEmpID],[FKProjectID],[FKClientID],[Hrs],[Description],[IsBillable],[Memo],[TBHours],[TCostRate],[TBillRate],[BillAmt],[CostAmt],[BudAmt],[BillHrs],[UnBillHrs],[ApproveStatus],[TaskStatus],[ProjectCode],[ProjectName],[TaskName],[BHours],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[TType]";
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.ExpensesbyClient)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ClientReport\\ExpensesbyClient.rdlc";
                RecType = "Expenses";
                StrReportName = "Expenses by Client";
                ColStr = "[ClientCode],[ClientName],[Hrs],[BillAmt],[CostAmt]";
                SortBy = "ClientCode";
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.ExpensesbyItem)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ClientReport\\ExpensesbyItem.rdlc";
                RecType = "Expenses";
                StrReportName = "Expenses by Item";
                ColStr = "[TaskDate],[Hrs],[Description],[IsBillable],[TBHours],[TCostRate],[TBillRate],[BillAmt],[CostAmt],[Amount],[ProjectCode],[ProjectName],[TaskName],[BHours],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[MU],[Profit],[IsReimb]";

                SortBy = "ClientCode";
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.EmployeeExpensesbyItem)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ClientReport\\ExpensesbyItem.rdlc";
                RecType = "Expenses";
                StrReportName = "Expenses by Item";
                ColStr = "[TaskDate],[Hrs],[Description],[IsBillable],[TBHours],[TCostRate],[TBillRate],[BillAmt],[CostAmt],[Amount],[ProjectCode],[ProjectName],[TaskName],[BHours],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[MU],[Profit],[IsReimb]";

                SortBy = "ClientCode";
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.EmployeeExpensesReport)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\EmployeeReport\\EmployeeExpensesReport.rdlc";
                RecType = "Expenses";
                StrReportName = "Employee Expenses Report";
                ColStr = "[TaskDate],[Hrs],[Description],[IsBillable],[TBHours],[TCostRate],[TBillRate],[BillAmt],[CostAmt],[Amount],[ProjectCode],[ProjectName],[TaskName],[BHours],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[MU],[Profit],[IsReimb]";

                SortBy = "ClientCode";
            }


            var dresult = DateRange.getLastDates(HidDateRange.Value, HidFromDate.Value, HidToDate.Value, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

            ds = objda.GetTimeandExpReport(0, 0, SortBy, "", ColStr, dresult.DateWise, dresult.fromdate, dresult.todate, 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), HidEmpID.Value, HidClient.Value, HidProject.Value, "", 0, HidApproved.Value, HidBilled.Value, HidBillable.Value, RecType);




            objcompany.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
            DataSet dsCompany = objcompany.GetCompanyForReport();




            strAddress = objgen.SetAddress(Convert.ToString(dsCompany.Tables[0].Rows[0]["Address1"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Address2"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["CountryName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["StateName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["CityName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["TahsilName"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["ZIP"]));
            strcontact = objgen.SetContactDetail(Convert.ToString(dsCompany.Tables[0].Rows[0]["Phone"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Fax"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Email"]), Convert.ToString(dsCompany.Tables[0].Rows[0]["Website"]));

            ReportParameter[] param = new ReportParameter[5];
            param[0] = new ReportParameter("companyname", Convert.ToString(dsCompany.Tables[0].Rows[0]["CompanyName"]), true);
            param[1] = new ReportParameter("companyaddress", strAddress, true);
            param[2] = new ReportParameter("companyphone", strcontact, true);
            param[3] = new ReportParameter("reportfilter", dresult.datetext, true);
            param[4] = new ReportParameter("reportname", StrReportName, true);

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