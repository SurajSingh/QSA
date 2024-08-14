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
    public partial class UserMaster : System.Web.UI.MasterPage
    {
        public string strPanelName = "", strUserName = "", strProfilePic = "", CompanyName = "", StrBranch = "", strBranchName = "", strFinancialYear = "";
        public static string CSSVersion = "", JSVersion = "", PageJSVersion = "";
        public string strSchedule = "", strAnnouncement = "";


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (!ClsLogin.ValidateLogin())
                {
                    Response.Redirect("Logout.aspx");
                }

                if (Request.QueryString["HotLink"] != null)
                {
                    if (Convert.ToInt64(Request.QueryString["HotLink"]) == 1)
                    {
                        HidHotLink.Value = "1";
                        Page.Header.Controls.Add(
        new System.Web.UI.LiteralControl("<link rel=\"stylesheet\" type=\"text/css\" href=\"" + ResolveUrl("~/Users/assets/css/hotLink.css") + "\" />"));
                    }
                }
            }
            FillMenu();
            FillProfileInfo();
        }

        private void FillProfileInfo()
        {

            CompanyName = Session["OrgName"].ToString();
            strUserName = Session["Name"].ToString();
            HidUserID.Value= Convert.ToString(Session["UserID"]);
            HidDateFormat.Value = Convert.ToString(Session["DateFormat"]);
            HidCurrencyName.Value = Convert.ToString(Session["CurrencyName"]);
            hidCurrencyID.Value = Convert.ToString(Session["FKCurrencyID"]);
            HidWebURL.Value = Convert.ToString(System.Web.Configuration.WebConfigurationManager.AppSettings["WebURL"]);
            if (Convert.ToString(Session["PhotoURL"]) == "")
            {
                strProfilePic = "images/no_image.png";
            }
            else
            {
                strProfilePic = "UserFiles/Profile/" + Convert.ToString(Session["PhotoURL"]);
            }

        }
        private void FillMenu()
        {
            ClsCommon objGeneral = new ClsCommon();
            litMenu.Text = objGeneral.GetMenuHTML(Convert.ToInt64(HttpContext.Current.Session["UserID"]), (DataTable)HttpContext.Current.Session["PageTable"]);


        }
    }
}