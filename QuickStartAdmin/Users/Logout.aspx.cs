using BL.Master;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateLogin())
            {
                blUser objda = new blUser();
                DataSet ds = new DataSet();

                objda.PKUserID = Convert.ToInt64(Session["UserID"]);                
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                ds = objda.Logout();
            }
            Session.Abandon();
            Response.Redirect("/Login.aspx");
        }
    }
}