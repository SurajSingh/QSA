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
        public static string GetProjectDetail(Int64 PKID,Int64 FKProjectID)
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
               

                DataSet ds = objda.GetProjectDetail(PKID, FKProjectID,Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }


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
        public static string SaveData(Int64 PKID, object InvDate, Int64 FKProjectID, Int64 SNo, string Prefix, string Suffix, string CPerson, string CPersonTitle, string Address1, string Address2, Int64 FKTahsilID, Int64 FKCityID, Int64 FKStateID, Int64 FKCountryID, string ZIP, decimal SubAmt, Int64 FKTaxID, decimal TaxPer, decimal TaxAmt, decimal Amount, decimal Discount, decimal NetAmount, decimal Retainage, string Remarks, Int64 FKCurrencyID, string StrTimeEntries, string StrExpenseEntries, string dtItemStr)
        {
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
                DataSet dsResult = objda.InsertInvoice(PKID, InvDate, FKProjectID, SNo, Prefix, Suffix, CPerson, CPersonTitle, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, SubAmt, FKTaxID, TaxPer, TaxAmt, Amount, Discount, NetAmount, Retainage, Remarks, FKCurrencyID, StrTimeEntries,StrExpenseEntries, dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

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