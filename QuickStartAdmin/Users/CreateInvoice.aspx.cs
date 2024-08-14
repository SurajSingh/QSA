using BL;
using BL.Master;
using BL.Timesheet;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Data;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using BL.Classes.Billing;
using System.Runtime.InteropServices.ComTypes;

namespace QuickStartAdmin.Users
{
    public partial class CreateInvoice : System.Web.UI.Page
    {
        public string PageVersion = "17052022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.CreateInvoice, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.CreateInvoice).ToString();
            }


            if (Request.QueryString["PKID"] == null)
            {
                if (ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.CreateInvoice, ClsRoles.IsAdd))
                {
                    ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.CreateInvoice).ToString();
                }
                else
                {
                    Response.Redirect("Dashboard.aspx");
                }
            }
            else
            {
                if (ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.CreateInvoice, ClsRoles.IsEdit))
                {
                    ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.CreateInvoice).ToString();
                    HidID.Value = Request.QueryString["PKID"].ToString();
                }
                else
                {
                    Response.Redirect("Dashboard.aspx");
                }

                
            }
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetProjectDetail(Int64 PKID,Int64 FKProjectID, object InvFromDate, object InvToDate)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.CreateInvoice, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blGetMaster objda = new blGetMaster();
                ClsGeneral objgen = new ClsGeneral();

                if ((string)InvFromDate != "" && (string)InvToDate != "")
                {
                    InvFromDate = (DateTime.ParseExact(InvFromDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));
                    InvToDate = (DateTime.ParseExact(InvToDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));
                }
                else
                {
                    InvFromDate = new DateTime(1900, 1, 1);
                    InvToDate = (DateTime.ParseExact(InvToDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));//new DateTime(1900, 1, 1); //new DateTime(1900, 1, 1);
                }


                DataSet ds = objda.GetProjectDetail(PKID, FKProjectID,Convert.ToInt64(HttpContext.Current.Session["OrgID"]), InvFromDate,InvToDate);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DateTime lastInvoiceDate = new DateTime();

                    string contractType = Convert.ToString(ds.Tables[0].Rows[0]["ContractType"]);
                    if (contractType == "Recurring With Cap")
                    {
                        int billingFreq = Convert.ToInt32(ds.Tables[0].Rows[0]["FKBillingFrequency"]);
                        string contractAmount = Convert.ToString(ds.Tables[0].Rows[0]["ContractAmt"]);
                        Decimal recurringAmt = Convert.ToDecimal(ds.Tables[0].Rows[0]["BillPerCycle"]);
                        if (ds.Tables[5].Rows.Count > 0)
                        {
                            lastInvoiceDate = Convert.ToDateTime(ds.Tables[5].Rows[0]["InvDate"]);
                        }

                        DateTime startDateOfProject = Convert.ToDateTime(ds.Tables[0].Rows[0]["StartDate"]);



                        BillingFrequency billingFrequencyValue = (BillingFrequency)billingFreq;
                        DateTime projectStartDate = startDateOfProject;

                        SkipBillingCycleCalculator calculator = new SkipBillingCycleCalculator(recurringAmt, billingFrequencyValue, projectStartDate);

                        DateTime newlastInvoiceDate = lastInvoiceDate;
                        DateTime today = DateTime.Today;

                        int cyclesSkipped = calculator.CalculateSkippedCycles(newlastInvoiceDate, today);
                        decimal invoiceLimit = calculator.CalculateInvoiceLimit(cyclesSkipped);

                        DataTable dt = new DataTable("SkippedRecCycle");
                        dt.Columns.Add(new DataColumn("SkippedCycle", typeof(int)));
                        dt.Columns.Add(new DataColumn("InvoiceLimit", typeof(decimal)));

                        DataRow dr = dt.NewRow();
                        dr["SkippedCycle"] = cyclesSkipped;
                        dr["InvoiceLimit"] = invoiceLimit;
                        dt.Rows.Add(dr);
                        ds.Tables.Add(dt);

                    }
                }
                //calculate Recurring amount based on billing cycle skipped and contrac amount
                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }

        //Added by Nilesh to show all unbilled Expensed and Task on demand - 20/04/24 - Start
        [WebMethod]
        [ScriptMethod(ResponseFormat=ResponseFormat.Json)]
        public static string GetAllUnbilledTask(Int64 PKID, Int64 FKProjectID, object InvFromDate, object InvToDate, string ChkIsChecked)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.CreateInvoice, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blGetMaster objda = new blGetMaster();
                ClsGeneral objgen = new ClsGeneral();

                if (ChkIsChecked == "True")
                {
                    InvFromDate = new DateTime(1900, 1, 1);
                    InvToDate = new DateTime(1900, 1, 1);
                }
                else
                {
                    if (string.IsNullOrEmpty((string)InvFromDate))
                    {
                        InvFromDate = new DateTime(2000, 1, 1);
                    }
                    InvToDate = new DateTime(2000, 1, 1);
                }
                



                DataSet ds = objda.GetAllUnbilledTask(PKID, FKProjectID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), InvFromDate, InvToDate);

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetAllUnbilledExpenses(Int64 PKID, Int64 FKProjectID, object InvFromDate, object InvToDate, string ChkIsChecked)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.CreateInvoice, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blGetMaster objda = new blGetMaster();
                ClsGeneral objgen = new ClsGeneral();

                if (ChkIsChecked == "True")
                {
                    InvFromDate = new DateTime(1900, 1, 1);
                    InvToDate = new DateTime(1900, 1, 1);
                }
                else
                {
                    //InvFromDate = new DateTime(2000, 1, 1);
                    InvToDate = new DateTime(2000, 1, 1);
                }




                DataSet ds = objda.GetAllUnbilledExpenses(PKID, FKProjectID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), InvFromDate, InvToDate);

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        //Added by Nilesh to show all unbilled Expensed and Task on demand - 20/04/24 - End
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.CreateInvoice, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blBilling objda = new blBilling();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetInvoice(0, 0, "", "", false, null, null, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), "","","",0,"Print");
                             

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, object InvDate, Int64 FKProjectID, Int64 SNo, string Prefix, string Suffix, string CPerson, string CPersonTitle, string Address1, string Address2, Int64 FKTahsilID, Int64 FKCityID, Int64 FKStateID, Int64 FKCountryID, string ZIP, decimal SubAmt, Int64 FKTaxID, decimal TaxPer, decimal TaxAmt, decimal Amount, decimal Discount, decimal NetAmount, decimal Retainage, string Remarks, Int64 FKCurrencyID, string StrTimeEntries, string StrExpenseEntries, string dtItemStr, Int64 IsDeleted, Int64 IsArchieved, Int64 FKManagerID, string SubmitType, string ApproveAction, string ApproveRemark, object InvFromDate, object InvToDate)
        {
            //Added two extra paratmeter to set the Isdeleted and IsArchieved value which is by default 0
            string result = "";
            int status = 1;
           
            if (dtItemStr == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.CreateInvoice, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }


            }    

            if (status == 1)
            {
                blBilling objda = new blBilling();
                ClsGeneral objgen = new ClsGeneral();
                DataSet dsItem = new DataSet();

                if ((string)InvFromDate != "" && (string)InvToDate != "")
                {
                    InvFromDate = (DateTime.ParseExact(InvFromDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));
                    InvToDate = (DateTime.ParseExact(InvToDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));
                }
                else
                {
                    InvFromDate = new DateTime(1900, 1, 1);
                    InvToDate = new DateTime(1900, 1, 1);
                }

                if (dtItemStr != "")
                {
                    DataTable dtItem = objgen.DeserializeTooDataTable(dtItemStr);
                    dtItem.TableName = "Detail";
                    dtItem.AcceptChanges();
                    dsItem.Tables.Add(dtItem);
                    dsItem.AcceptChanges();
                }

                InvDate = (DateTime.ParseExact(InvDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.CreateInvoice;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet dsResult = objda.InsertInvoice(PKID, InvDate, FKProjectID, SNo, Prefix, Suffix, CPerson, CPersonTitle, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, SubAmt, FKTaxID, TaxPer, TaxAmt, Amount, Discount, NetAmount, Retainage, Remarks, FKCurrencyID, StrTimeEntries,StrExpenseEntries, dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]), IsDeleted, IsArchieved, FKManagerID, SubmitType, ApproveAction, ApproveRemark,InvFromDate,InvToDate);

                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.CreateInvoice, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blBilling objda = new blBilling();
                ClsGeneral objgen = new ClsGeneral();


                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.CreateInvoice;
                DataSet dsResult = objda.DeleteInvoice(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}