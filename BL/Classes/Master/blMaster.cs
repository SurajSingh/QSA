using System;
using System.Data;

namespace BL.Master
{
    public class blMaster : DAL.clsDAL
    {
        public DataSet GetAllRoles()
        {
            dbcommand = db.GetStoredProcCommand("uspGetAllRoles");
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetRolesByCompany(Int64 FKCompanyID, string OrgType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetRolesByCompany", FKCompanyID, OrgType);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetPagesByCompany(Int64 FKCompanyID, string OrgType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetPagesByCompany", FKCompanyID, OrgType);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetCountry(Int64 PKID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetCountry", PKID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetState(Int64 FKCountryID, Int64 PKID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetState", FKCountryID, PKID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetCity(Int64 FKStateID, Int64 PKID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetCity", FKStateID, PKID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetTahsil(Int64 FKCityID, Int64 PKID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTahsil", FKCityID, PKID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertCountryStateCity(Int64 PKID, string Name1, string Name2, string Name3, Int64 FKCountryID, Int64 FKStateID, Int64 FKCityID, Int64 RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertCountryStateCity", PKID, Name1, Name2, Name3, FKCountryID, FKStateID, FKCityID, RecType, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteCountryStateCity(Int64 PKID, Int64 RecType)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteCountryStateCity", PKID, RecType, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetUserPages(Int64 FKUserID, string RoleType)
        {
            dbcommand = db.GetStoredProcCommand("uspGetUserPages", FKUserID, RoleType);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetTimezoneID()
        {
            dbcommand = db.GetStoredProcCommand("uspGetTimezoneID");
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetCurrency()
        {
            dbcommand = db.GetStoredProcCommand("uspGetCurrency");
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetContractType()
        {
            dbcommand = db.GetStoredProcCommand("uspGetContractType");
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetBillingFrequency()
        {
            dbcommand = db.GetStoredProcCommand("uspGetBillingFrequency");
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetPaymentTypeMaster()
        {
            dbcommand = db.GetStoredProcCommand("uspGetPaymentTypeMaster");
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetPaymentModeMaster()
        {
            dbcommand = db.GetStoredProcCommand("uspGetPaymentModeMaster");
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet GetTableLayout(Int64 FKPageID, string TableID, Int64 FKCompanyID, Int64 FKUserID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTableLayout", FKPageID, TableID, FKCompanyID, FKUserID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet InsertTableLayout(Int64 FKPageID, string TableID, object XMLDef, Int64 FKCompanyID, Int64 FKUserID, bool ForAllUser, bool IsReset)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertTableLayout", FKPageID, TableID, XMLDef, FKCompanyID, FKUserID, ForAllUser, IsReset);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertDepartment(Int64 PKID, string Name, string DeptDesc, Int64 FKManagerID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertDepartment", PKID, Name, DeptDesc, FKManagerID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteDepartment(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteDepartment", PKID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetDepartment(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, Int64 PKID, string Name, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetDepartment", PageSize, PageNo, SortBy, SortDir, PKID, Name, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet InsertDesignation(Int64 PKID, string Name, string DeptDesc, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertDesignation", PKID, Name, DeptDesc, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteDesignation(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteDesignation", PKID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetDesignation(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, Int64 PKID, string Name, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetDesignation", PageSize, PageNo, SortBy, SortDir, PKID, Name, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }


        public DataSet InsertTaxMaster(Int64 PKID, string Name, decimal TaxPercentage, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertTaxMaster", PKID, Name, TaxPercentage, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeleteTaxMaster(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteTaxMaster", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetTaxMaster(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, Int64 PKID, string Name, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTaxMaster", PageSize, PageNo, SortBy, SortDir, PKID, Name, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet InsertPaymentTerm(Int64 PKID, string TermTitle, string PayTerm, Int64 GraceDays, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertPaymentTerm", PKID, TermTitle.Trim(), PayTerm, GraceDays, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet DeletePaymentTerm(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeletePaymentTerm", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetPaymentTerm(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetPaymentTerm", PKID, FKCompanyID);
            return db.ExecuteDataSet(dbcommand);
        }

        public DataSet InsertTaskMaster(Int64 PKID, string TaskCode, string TaskName, string Description, bool IsBillable, string ActiveStatus, Int64 FKDeptID, decimal CostRate, decimal BillRate, string TEType, decimal Tax, decimal BHours, bool isReimb, decimal MuRate, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertTaskMaster", PKID, TaskCode.Trim(), TaskName.Trim(), Description.Trim(), IsBillable, ActiveStatus, FKDeptID, CostRate, BillRate, TEType, Tax, BHours, isReimb, MuRate, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);

        }
        public DataSet DeleteTaskMaster(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteTaskMaster", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetTaskMaster(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, Int64 PKID, Int64 FKCompanyID, string TaskCode, Int64 FKDeptID, string TEType, string ActiveStatus)
        {
            dbcommand = db.GetStoredProcCommand("uspGetTaskMaster", PageSize, PageNo, SortBy, SortDir, PKID, FKCompanyID, TaskCode, FKDeptID, TEType, ActiveStatus);
            return db.ExecuteDataSet(dbcommand);


        }



        public DataSet InsertClient(Int64 PKID, Int64 FKManagerID, string Code, string Company, string CPerson, string CPersonTitle, string ActiveStatus, string Address1, string Address2, Int64 FKTahsilID, Int64 FKCityID, Int64 FKStateID, Int64 FKCountryID, string ZIP, string EMailID, string Phone1, string Phone2, string Mobile, string Fax, string Website, string PWD, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertClient", PKID, FKManagerID, Code.Trim(), Company.Trim(), CPerson.Trim(), CPersonTitle.Trim(), ActiveStatus, Address1.Trim(), Address2.Trim(), FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, EMailID.Trim(), Phone1, Phone2, Mobile, Fax, Website.Trim(), PWD.Trim(), FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);

        }
        public DataSet DeleteClient(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteClient", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetClient(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, Int64 PKID, Int64 FKCompanyID, string ClientName, string ActiveStatus)
        {
            dbcommand = db.GetStoredProcCommand("uspGetClient", PageSize, PageNo, SortBy, SortDir, PKID, FKCompanyID, ClientName, ActiveStatus);
            return db.ExecuteDataSet(dbcommand);


        }


        public DataSet InsertProject(Int64 PKID, Int64 FKClientID, string ProjectCode, string ProjectName, Int64 FKManagerID, Int64 FKContractTypeID, string ProjectStatus, decimal ContractAmt, decimal ExpAmt, decimal ServiceAmt, decimal BudgetedHours, object Startdate, object DueDate, decimal CompletePercent, string PONo, string Remark, Int64 FKCurrencyID, bool ISCustomInvoice, string InvoicePrefix, string InvoiceSuffix, Int64 InvoiceSNo, Int64 FKBillingFrequency, decimal GRT, decimal ExpenseTax, Int64 FKTaxID, Int64 FKTermID, bool TBillable, bool TMemoRequired, bool EBillable, bool EMemoRequired, bool TDesReadonly, bool EDesReadOnly, decimal recurringAmt, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspInsertProject", PKID, FKClientID, ProjectCode.Trim(), ProjectName.Trim(), FKManagerID, FKContractTypeID, ProjectStatus, ContractAmt, ExpAmt, ServiceAmt, BudgetedHours, Startdate, DueDate, CompletePercent, PONo, Remark.Trim(), FKCurrencyID, ISCustomInvoice, InvoicePrefix.Trim(), InvoiceSuffix.Trim(), InvoiceSNo, FKBillingFrequency, GRT, ExpenseTax, FKTaxID, FKTermID, TBillable, TMemoRequired, EBillable, EMemoRequired, TDesReadonly, EDesReadOnly, recurringAmt, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);

        }
        public DataSet DeleteProject(Int64 PKID, Int64 FKCompanyID)
        {
            dbcommand = db.GetStoredProcCommand("uspDeleteProject", PKID, FKCompanyID, FKUserID, FKPageID, IPAddress);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetProject(Int64 PageSize, Int64 PageNo, string SortBy, string SortDir, Int64 PKID, Int64 FKCompanyID, string ProjectName, Int64 FKClientID, string ActiveStatus, Int64 FKContractTypeID)
        {
            dbcommand = db.GetStoredProcCommand("uspGetProject", PageSize, PageNo, SortBy, SortDir, PKID, FKCompanyID, ProjectName, FKClientID, ActiveStatus, FKContractTypeID);
            return db.ExecuteDataSet(dbcommand);
        }
        public DataSet GetProjectByCodes(string projectCodes)
        {
            dbcommand = db.GetStoredProcCommand("uspGetProjectByCode", projectCodes);
            return db.ExecuteDataSet(dbcommand);


        }

        //Added by Nilesh
        public DataSet GetProjectByFilter(string ProjectCode)
        {
            string SQL = String.Format("SELECT * FROM tblProject WHERE ProjectCode = '{0}'", ProjectCode);
            return db.ExecuteDataSet(CommandType.Text, SQL);
        }

        public DataSet GetProjectById(string ProjectId)
        {
            string SQL = String.Format("SELECT * FROM tblProject INNER JOIN tblProjectDetail ON (tblProject.PKID = tblProjectDetail.FKProjectID) WHERE PKID = {0}", ProjectId);
            return db.ExecuteDataSet(CommandType.Text, SQL);
        }

        public decimal GetInvoiceAmountForProject(string ProjectId)
        {
            string SQL = String.Format("SELECT ISNULL(SUM(tblInvoiceDetail.Amount),0) AS TotalInvoicedAmount FROM tblInvoice INNER JOIN tblProject ON (tblInvoice.FKProjectID = tblProject.PKID AND tblProject.PKID = {0} ) INNER JOIN tblInvoiceDetail ON (tblInvoice.PKID = tblInvoiceDetail.FKID)", ProjectId);
            return Convert.ToDecimal(db.ExecuteDataSet(CommandType.Text, SQL).Tables[0].Rows[0]["TotalInvoicedAmount"]);
        }


        public DataSet GetTaskByFilter(string TaskCode, string TaskName)
        {
            string SQL = String.Format("SELECT * FROm tblTask WHERE TaskCode = '{0}' AND TaskName = '{1}'", TaskCode, TaskName);
            return db.ExecuteDataSet(CommandType.Text, SQL);
        }

    }
}
