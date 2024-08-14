using BL.Master;
using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class SettingAccount : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["OrgID"] == null || Session["PhotoURL"] == null  || Session["Name"] == null || Session["UserID"] == null || Session["DateFormat"]==null || Session["RoleType"] == null)
            {
                Response.Redirect("logout.aspx");
            }
           
            
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string UserRoleSetting()
        {

            string result = "";
            result=ClsLogin.SettingBranch();
            return result;
        }
       
    }
}