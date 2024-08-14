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
    public partial class TimeExpensesDetailbyClientProject : System.Web.UI.Page
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
            string strSort = "ProjectCode";

            if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.TimeExpensesDetailbyClientProject)
            {
                if (HidWithCost.Value == "1")
                {
                    path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ClientReport\\TimeExpensesDetailbyClientProject.rdlc";

                    StrReportName = "Time & Expenses Detail by Client And Project (With Cost)";
                }
                else
                {
                    path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ClientReport\\TimeExpensesDetailbyClientProjectWithoutCost.rdlc";
                    StrReportName = "Time & Expenses Detail by Client And Project";
                }

             
                ColStr = "[PKID],[TaskDate],[FKTaskID],[FKEmpID],[FKProjectID],[FKClientID],[Hrs],[Description],[IsBillable],[Memo],[TBHours],[TCostRate],[TBillRate],[BillAmt],[CostAmt],[Amount],[BudAmt],[BillHrs],[UnBillHrs],[ApproveStatus],[TaskStatus],[ProjectCode],[ProjectName],[TaskName],[BHours],[TBHours],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[TType]";
            }
            if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.EmployeeExpensesbyItem)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ClientReport\\ExpensesbyItem.rdlc";

                StrReportName = "Employee Expenses by Item";


                ColStr = "[PKID],[TaskDate],[FKTaskID],[FKEmpID],[FKProjectID],[FKClientID],[Hrs],[Description],[IsBillable],[Memo],[TBHours],[TCostRate],[TBillRate],[BillAmt],[CostAmt],[Amount],[BudAmt],[BillHrs],[UnBillHrs],[ApproveStatus],[TaskStatus],[ProjectCode],[ProjectName],[TaskName],[BHours],[TBHours],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[TType]";
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.TimeExpensebyClientProjectandEmployee)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ClientReport\\TimeExpensebyClientProjectandEmployee.rdlc";
                StrReportName = "Time & Expense by Client, Project and Employee";


                ColStr = "[FKProjectID],[FKClientID],[Hrs],[BillAmt],[CostAmt],[Amount],[BudAmt],[ProjectCode],[ProjectName],[BHours],[TBHours],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[TType]";
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.TimeExpensesSummarybyClient)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\ClientReport\\TimeExpensesSummarybyClient.rdlc";
                StrReportName = "TimeExpensesSummarybyClient";
                strSort = "ClientCode";

                ColStr = "[FKClientID],[Hrs],[BillAmt],[Amount],[TBHours],[ServiceAmt],[ExpAmt],[ClientCode],[ClientName]";
            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.AnalysisbyProjectEmployeeTask)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\TaskReport\\AnalysisbyProjectEmployeeTask.rdlc";
                StrReportName = "AnalysisbyProjectEmployeeTask";
                strSort = "LoginID";

                ColStr = "[FKProjectID],[FKClientID],[Hrs],[BillAmt],[TBillRate],[CostAmt],[Amount],[BudAmt],[ProjectCode],[ProjectName],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[TaskName],[TaskDescription]";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.AnalysisbyProjectTaskEmployee)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\TaskReport\\AnalysisbyProjectTaskEmployee.rdlc";
                StrReportName = "AnalysisbyProjectEmployeeTask";
                strSort = "LoginID";

                ColStr = "[FKProjectID],[FKClientID],[Hrs],[BillAmt],[TBillRate],[CostAmt],[Amount],[BudAmt],[ProjectCode],[ProjectName],[ClientCode],[ClientName],[EmpName],[LoginID],[ManagerName],[TaskName],[TaskDescription]";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.AnalysisbyEmployeeTask)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\TaskReport\\AnalysisbyEmployeeTask.rdlc";
                StrReportName = "AnalysisbyEmployeeTask";
                strSort = "LoginID";

                ColStr = "[TaskName],[TaskDescription],[TBHours],[Hrs],[BillAmt],[CostAmt],[Amount],[BudAmt],[EmpName],[LoginID]";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.TaskSummary)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\TaskReport\\TaskSummary.rdlc";
                StrReportName = "TaskSummary";
                strSort = "[TaskName]";

                ColStr = "[TaskName],[TaskDescription],[TBHours],[Hrs],[BillAmt],[CostAmt],[Amount],[BudAmt]";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.ExpensesSummary)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\TaskReport\\ExpensesSummary.rdlc";
                StrReportName = "ExpensesSummary";
                strSort = "[TaskName]";

                ColStr = "[TaskName],[TaskDescription],[CostAmt],[MU],[Amount]";

            }
            else if (Convert.ToInt64(HidPageID.Value) == (Int64)ClsPages.WebPages.TimeSummarybyEmployee)
            {
                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\RDLC\\DesignFiles\\Reports\\TimesheetReport\\TimeSummarybyEmployee.rdlc";
                StrReportName = "TimeSummarybyEmployee";
                strSort = "[LoginID]";

                ColStr = "[EmpName],[Hrs],[BillHrs],[UnBillHrs],[LoginID]";

            }

            var dresult = DateRange.getLastDates(HidDateRange.Value, HidFromDate.Value, HidToDate.Value, Convert.ToString(HttpContext.Current.Session["DateFormat"]));
            ds = objda.GetTimeandExpReport(0, 0, strSort, "", ColStr, dresult.DateWise, dresult.fromdate, dresult.todate, 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), HidEmpID.Value, HidClient.Value, HidProject.Value, "", Convert.ToInt64(HidFKManagerIDSrch.Value), HidApproved.Value, HidBilledSrch.Value, HidBillable.Value, HidRecType.Value);





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