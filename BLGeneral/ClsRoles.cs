namespace BLGeneral
{
    public static class ClsRoles
    {
        public enum UserRoles
        {

            ProfilePicture = 1,
            CompanyInformation = 2,
            EmailSettings = 3,
            PaymentTerms = 4,
            BillingSettings = 5,
            InvoiceTemplate = 6,
            InvoiceEmailTemplate = 7,
            SchedulingEmailReceivers = 8,
            LeaveRequestEmailReceivers = 9,
            AttandenceMachineSettings = 10,
            Announcements = 11,
            ViewAppointments = 21,
            ScheduleAvailability = 22,
            ScheduleAvailabilityOthers = 23,
            ViewAppointmentsOthers = 24,
            TransferAsset = 31,
            AssetCategory = 32,
            AssetMaster = 33,
            VendorMaster = 34,
            FileManager = 51,
            FileSharing = 52,
            FileCategories = 53,
            CreateInvoice = 71,
            InvoiceList = 72,
            ReceivePayment = 73,
            PaymentReview = 74,
            TransactionStatements = 75,
            //Added by NIelsh to add new menus -start 09_10_23
            TrashInvoices = 76,
            ArchiveInvoiceList = 77,
            //DeletedInvoiceList = 7601,
            //Added by NIelsh to add new menus -End 09_10_23
            EmployeeGroups = 101,
            ClientGroups = 102,
            ProjectGroups = 103,
            ExpenseGroups = 104,


            LeaveRequest = 121,
            ApproveLeaveRequest = 122,
            IssueLeave = 123,
            HolidayCalendar = 124,
            LeaveSettings = 125,

            ProjectForecasting = 161,
            ProjectAllocation = 162,
            ProjectBudgeting = 163,
            TaxClientSetup = 164,
            TaxClientLog = 165,
            TaxMasterFile = 166,
            Schedule = 191,

            EnterTimeSheet = 201,
            ApproveTimeSheet = 202,
            EmployeeExpenseEntry = 203,
            EmployeeTaskAssignment = 204,
            ApproveEmployeeExpenses = 205,
            DescriptionInTimesheet = 206,
            BillRateInTimesheet = 207,
            PayRateInTimesheet = 208,
            MemoInTimesheet = 209,
            BillableCheckUncheckInTimesheet = 210,

            CostRateInExpenseEntry = 211,
            MemoInExpenseEntry = 212,
            BillableCheckUncheckInExpenseEntry = 213,
            ReimbursableCheckUncheckInExpenseEntry = 214,


            Employees = 251,
            Projects = 252,
            Clients = 253,
            ClientAddressMap = 254,
            TaskCodes = 255,
            ExpenseCodes = 256,
            Departments = 257,
            Designations = 258,
            TaxMaster = 259,
            InformationTypeMaster = 260,

            AgingReport = 301,
            Analysis = 302,
            AssetReport = 303,
            BillingReport = 304,
            BudgetReport = 305,
            ClientReport = 306,
            ClientScheduleReport = 307,
            EmployeeReport = 308,
            LeaveReport = 309,
            ProjectReport = 310,
            TaskReport = 311,
            TimesheetReport = 312,
            AgingReport90Days = 30101,
            AgingSummaryReport = 30102,
            AgingwithClientAddress = 30103,
            AgingSummarywithCredit = 30104,
            AHoursBHoursComparisonbyEmployee = 30201,
            AHoursBHoursComparisonbyProject = 30202,
            ProjectAnalysisReport = 30203,
            ChartReport = 30204,
            AssetReportByDepartment = 30301,
            AssetReportByEmployee = 30302,
            AssetReportByLocation = 30303,
            AssetReportByCondition = 30304,
            AssetReportByCategory = 30305,
            ApprovedTimeandExpenseswithMemos = 30401,
            InvoiceRegister = 30402,
            InvoiceRegisterwithCosts = 30403,
            BillingStatementbyClient = 30404,
            BillingStatementbyProject = 30405,
            PercentageBilled = 30406,
            EmployeeDefaultBillRates = 30407,
            BilledTimeandExpensesDetailbyProjectEmplo = 30408,
            UnBilledTimeandExpensesDetailbyProjectEm = 30409,
            BudgetSummaryReport = 30501,
            BudgetDetailbyProjectEmployee = 30502,
            ClientMasterFileList = 30601,
            ClientMasterFileDetails = 30602,
            ExpensesbyClient = 30603,
            ExpensesbyItem = 30604,
            InvoiceRegisterbyClient = 30605,
            MonthlyBillingSummarybyClient = 30606,
            TimeExpensesDetailbyClientProject = 30607,
            TimeExpensebyClientProjectandEmployee = 30608,
            TimeExpensesSummarybyClient = 30609,
            ClientEmployeeandTimeMetrix = 30610,
            EmployeeClientandTimeMetrix = 30611,
            ScheduleReportbyClient = 30701,
            ScheduleReportbyEmployeeClient = 30702,
            ScheduleSummaryReport = 30703,
            PerformanceReport = 30801,
            EmployeeExpensesbyItem = 30802,
            EmployeeExpensesReport = 30803,
            CumulativeReport = 30804,
            EmployeeLeaveRegister = 30901,
            EmployeeLeaveSummary = 30902,
            ProjectMaster = 31001,
            ProjectForecastingReport = 31002,
            ProjectAllocationReport = 31003,
            ProjectBreakdownSummary = 31004,
            BudgetedTaskReport = 31101,
            AssignedTaskReport = 31102,
            TaskMasterFile = 31103,
            ExpensesCodeMasterFile = 31104,
            AnalysisbyProjectEmployeeTask = 31105,
            AnalysisbyProjectTaskEmployee = 31106,
            AnalysisbyEmployeeTask = 31107,
            GroupedActivityCodeMasterFile = 31108,
            TaskSummary = 31109,
            ExpensesSummary = 31110,
            EmployeeTimesheet = 31201,
            TimeSummarybyEmployee = 31202
        }
        public enum MemberRoles
        {
            MyProfile = 5021,
            ManageBiller = 5031,
            PayBills = 5051,
            TransactionHistory = 5071


        }
        public static string IsView { get { return "IsView"; } }
        public static string IsAdd { get { return "IsAdd"; } }
        public static string IsEdit { get { return "IsEdit"; } }
        public static string IsDelete { get { return "IsDelete"; } }




    }
}