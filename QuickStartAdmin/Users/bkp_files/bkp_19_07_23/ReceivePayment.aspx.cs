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
    public partial class ReceivePayment : System.Web.UI.Page
    {
        public string PageVersion = "12042022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
           
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.ReceivePayment, ""))
            {
                StrCurrency = Session["CurrencyName"].ToString();
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ReceivePayment).ToString();
            }


            if (Request.QueryString["PKID"] == null)
            {
                if (ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ReceivePayment, ClsRoles.IsAdd))
                {
                    ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ReceivePayment).ToString();
                }
                else
                {
                    Response.Redirect("Dashboard.aspx");
                }
            }
            else
            {
                if (ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ReceivePayment, ClsRoles.IsEdit))
                {
                    ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ReceivePayment).ToString();
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
        public static string GetInvForAdjustment(Int64 PKID, Int64 FKClientID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ReceivePayment, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blBilling objda = new blBilling();
                ClsGeneral objgen = new ClsGeneral();


                DataSet ds = objda.GetInvForAdjustment(PKID, FKClientID,0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ReceivePayment, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blBilling objda = new blBilling();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetPayment(0, 0, "", "", false, null, null, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), "", "",0, 0, "Print");

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, Int64 FKClientID, object TranDate, Int64 FKPaymentTypeID, Int64 FKPaymodeID, string TranID, bool IsRetainer, decimal Amount, decimal RetainerAmount, string dtItemStr)
        {
            string result = "";
            int status = 1;
           
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ReceivePayment, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
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

                TranDate = (DateTime.ParseExact(TranDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ReceivePayment;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet dsResult = objda.InsertPayment(PKID, FKClientID, TranDate, FKPaymentTypeID, FKPaymodeID, TranID, IsRetainer, Amount, RetainerAmount, dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ReceivePayment, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blBilling objda = new blBilling();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ReceivePayment;
                DataSet dsResult = objda.DeleteInvoice(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}