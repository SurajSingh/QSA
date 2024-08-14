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
    public partial class EmailSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.EmailSettings, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = Convert.ToString(HttpContext.Current.Session["OrgID"]);

            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EmailSettings, ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();
                objda.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                DataSet ds = objda.GetEmailSettings();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(string SenderEmail, string SenderPWD, string SMTPServer, Int32 SMTPPort, bool EnableSSL)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EmailSettings, ClsRoles.IsAdd))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();
                objda.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                DataSet ds = objda.InsertEmailSettings(SenderEmail, SenderPWD, SMTPServer, SMTPPort, EnableSSL);
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }


    }
}