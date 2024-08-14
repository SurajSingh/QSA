using BL.Master;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Data;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
namespace QuickStartAdmin.Users
{
    public partial class BillingSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.BillingSettings, ""))
            {
               
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.BillingSettings).ToString();

            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.BillingSettings, ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();
                objda.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                DataSet ds = objda.GetCompany();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(string InvoicePrefix, string InvoiceSuffix,Int64 InvoiceSNo)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.BillingSettings, ClsRoles.IsAdd))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();
                objda.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                objda.InvoicePrefix = InvoicePrefix;
                objda.InvoiceSuffix = InvoiceSuffix;
                objda.InvoiceSNo = InvoiceSNo;
                DataSet ds = objda.UpdateBillingSettings();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }


    }
}