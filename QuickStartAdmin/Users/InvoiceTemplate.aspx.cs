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
    public partial class InvoiceTemplate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.InvoiceTemplate, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = Convert.ToString(HttpContext.Current.Session["OrgID"]);

            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.InvoiceTemplate, ClsRoles.IsEdit))
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
        public static string SaveData(Int32 FKTemplateID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.InvoiceTemplate, ClsRoles.IsAdd))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();
                objda.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                objda.InvoiceSNo = FKTemplateID;
                DataSet ds = objda.UpdateInvoiceTemplate();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }


    }
}