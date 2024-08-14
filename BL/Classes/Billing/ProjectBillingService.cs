using BL.Classes.Scheduler;
using BL.Master;
using Hangfire;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace BL.Classes.Billing
{
    public class ProjectBillingService
    {

        private const int CT_FIXED = 1;
        private const int CT_HOURLY = 2;
        private const int CT_HNTE = 3;
        private const int CT_PERCENTAGE = 4;
        private const int CT_RECURRING = 5;
        private const int CT_RWC = 6;

        private readonly BillingFrequencyCalculator _billingFrequencyCalculator;

        public ProjectBillingService()
        {
            _billingFrequencyCalculator = new BillingFrequencyCalculator();
        }

        public void PostBillNotification(long projectId)
        {
            if (projectId <= 0) return;

            // Check project status and reschedule if necessary
            DataSet ds = GetProjectById(projectId);
            if (ds != null)
            {
                DataTable project = ds.Tables[0];
                string projectStatus = Convert.ToString(project.Rows[0]["ProjectStatus"]);
                int contractType = Convert.ToInt32(project.Rows[0]["FKContractTypeID"]);
                int billingFrequency = Convert.ToInt32(project.Rows[0]["FKBillingFrequency"]);
                int ManagerId = Convert.ToInt32(project.Rows[0]["FKManagerID"]);
                int CompanyId = Convert.ToInt32(project.Rows[0]["FKCompanyID"]);
                string ProjectName = Convert.ToString(project.Rows[0]["ProjectName"]);

                decimal ContractAmount = Convert.ToDecimal(project.Rows[0]["ContractAmt"]);

                if (projectStatus.ToLower() == "active")
                {
                    bool ContractAmountExceeded = true;
                    decimal InvoicedAmount = 0;

                    switch (contractType)
                    {
                        case CT_HNTE:
                        case CT_RWC:
                        case CT_FIXED:
                            //get combined invoice total for a project
                            InvoicedAmount = GetINvoicedAmountForProject(projectId);
                            ContractAmountExceeded = (InvoicedAmount >= ContractAmount);
                            break;
                        case CT_HOURLY:
                        case CT_PERCENTAGE:
                        case CT_RECURRING:
                            ContractAmountExceeded = false;
                            break;
                    }
                    if (ContractAmountExceeded == false && billingFrequency != BillingFrequencyCalculator.UPON_LIMIT)
                    {
                        string Frequency = "";
                        switch (billingFrequency)
                        {
                            case BillingFrequencyCalculator.WEEKELY: Frequency = "weekely"; break;
                            case BillingFrequencyCalculator.BI_WEEKELY: Frequency = "bi-weekely"; break;
                            case BillingFrequencyCalculator.SEMI_MONTHLY: Frequency = "semi-monthly";  break;
                            case BillingFrequencyCalculator.MONTHLY: Frequency = "monthly";  break;
                            case BillingFrequencyCalculator.BI_MONTHLY: Frequency = "bi-monthly";  break;
                            case BillingFrequencyCalculator.SEMI_ANNUALLY: Frequency = "semi-annually";  break;
                            case BillingFrequencyCalculator.ANNUALLY: Frequency = "annually";  break;
                            case BillingFrequencyCalculator.UPON_LIMIT: Frequency = "upon limit"; break;
                        }

                        string Announcement = String.Format("Create {0} invoice form the project {1}.", Frequency, ProjectName);

                        // Post the bill notification to the project manager
                        blCompany objda = new blCompany();
                        objda.FKUserID = ManagerId;
                        DataSet dt = objda.InsertAnnouncement(0,"Create Invoice",DateTime.Now.ToString(), Announcement,"Active",CompanyId);

                        //ScheduleNextBillNotification((int)projectId, billingFrequency);

                    }
                    else if (ContractAmountExceeded == true && billingFrequency == BillingFrequencyCalculator.UPON_LIMIT)
                    {
                        string Announcement = String.Format("Create upon limit invoice form the project {0}.", ProjectName);

                        // Post the bill notification to the project manager
                        blCompany objda = new blCompany();
                        objda.FKUserID = ManagerId;
                        DataSet dt = objda.InsertAnnouncement(0, "Create Invoice", DateTime.Now.ToString(), Announcement, "Active", CompanyId);

                        //remove the recurring job
                        string jobId = GenerateUniqueJobId(projectId);
                        StopScheduledJob(jobId);
                    }

                }
                else
                {
                    //remove the recurring job
                    string jobId = GenerateUniqueJobId(projectId);
                    StopScheduledJob(jobId);
                }

            }

        }

        public void ScheduleNextBillNotification(int ProjectId, int BillingFrequency)
        {
            if (BillingFrequency <= 0) return;
            if (ProjectId <= 0) return;

            // Generate unique job ID
            string jobId = GenerateUniqueJobId(ProjectId);

            //remove old Job if exist
            HangfireScheduler.DeleteRecurringJob(jobId);

            DateTime nextRun = _billingFrequencyCalculator.CalculateNextBillingDate(DateTime.Now, BillingFrequency);
            TimeSpan delay = nextRun - DateTime.Now;


            // Create the method call expression
            Expression<Action<ProjectBillingService>> methodCall = (Obj) => Obj.PostBillNotification(ProjectId);

            string cronExp = "";
            switch (BillingFrequency)
            {
                case BillingFrequencyCalculator.WEEKELY: cronExp = Hangfire.Cron.Weekly(); break;
                case BillingFrequencyCalculator.BI_WEEKELY: cronExp = "0 10 * * 3,5"; break;
                case BillingFrequencyCalculator.SEMI_MONTHLY: cronExp = "0 10 L */2 *";  break;
                case BillingFrequencyCalculator.MONTHLY: cronExp = Hangfire.Cron.Monthly(); break;
                case BillingFrequencyCalculator.BI_MONTHLY: cronExp = "0 10 15,L * *"; break;
                case BillingFrequencyCalculator.SEMI_ANNUALLY: cronExp = "0 10 L */6 *"; break;
                case BillingFrequencyCalculator.ANNUALLY: cronExp = Hangfire.Cron.Yearly(); break;
                case BillingFrequencyCalculator.UPON_LIMIT: cronExp = Hangfire.Cron.Daily(); break;
            }

            if (BillingFrequencyCalculator.UPON_LIMIT != BillingFrequency)
            {
                // Schedule the job using the unique job ID
                HangfireScheduler.ScheduleRecurringJob<ProjectBillingService>(jobId, methodCall, cronExp); // .ScheduleJob(methodCall, delay, jobId);
            }
            else
            {
                //BackgroundJob.Enqueue<ProjectBillingService>(methodCall);
            }
        }

        /*
        public void UpdateProjectStatus(int ProjectId,string ProjectStatus)
        {
            if (ProjectStatus == "OnHold" || ProjectStatus == "Inactive" || ProjectStatus == "Completed")
            {
                string jobId = GenerateUniqueJobId(ProjectId);
                StopScheduledJob(jobId);
            }
            // Update project status in the database
            SaveProject(project);
        }
        */

        public void StopScheduledJob(string jobId)
        {
            HangfireScheduler.DeleteRecurringJob(jobId);
        }

        private DataSet GetProjectById(long projectId)
        {
            blMaster objda = new blMaster();
            DataSet dt = objda.GetProjectById(projectId.ToString());
            // Logic to fetch the project by ID
            // ...
            return dt; // Placeholder
        }

        private decimal GetINvoicedAmountForProject(long projectId)
        {
            blMaster objda = new blMaster();
            decimal amount = objda.GetInvoiceAmountForProject(projectId.ToString());
            // Logic to fetch the project by ID
            // ...
            return amount; // Placeholder
        }


        public string GenerateUniqueJobId(long projectId)
        {
            return $"project_billing_{projectId}";
        }
    }
}

