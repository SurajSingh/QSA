using BLGeneral;
using System;
using System.Data;
using BL.Master;

namespace QuickStartAdmin
{
    public partial class Login : System.Web.UI.Page
    {
        blUser objda = new blUser();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Session.Abandon();
                if (Request.QueryString["TokenID"] != null && Request.QueryString["LoginID"]!=null)
                {
                    objda.LoginID = Request.QueryString["LoginID"].ToString();
                    objda.PWD = Request.QueryString["TokenID"].ToString();
                    objda.RecordType = "Login";
                    DataSet ds = objda.LoginWithToken();
                    ProcessLogin(ds);
                }
            }
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (txtLoginID.Text != "" && txtPassword.Text != "")
            {
                DataSet ds = new DataSet();
               
                objda.LoginID = txtLoginID.Text;
                objda.PWD = txtPassword.Text;
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();

                ds = objda.Login();
                ProcessLogin(ds);

            }


        }

        void ProcessLogin(DataSet ds)
        {
            if (ds.Tables[0].Rows.Count > 0)
            {
                if (Convert.ToInt32(ds.Tables[0].Rows[0]["Result"]) == 1)
                {
                    Session["PhotoURL"] = ds.Tables[0].Rows[0]["PhotoURL"];
                    Session["OrgName"] = ds.Tables[0].Rows[0]["CompanyName"];
                    Session["Name"] = ds.Tables[0].Rows[0]["Name"];
                    Session["UserID"] = ds.Tables[0].Rows[0]["PKUserID"];
                    Session["RoleType"] = ds.Tables[0].Rows[0]["RoleType"];
                    Session["OrgType"] = ds.Tables[0].Rows[0]["OrgTypeID"];
                    Session["OrgID"] = ds.Tables[0].Rows[0]["FKCompanyID"];
                    Session["DateFormat"] = ds.Tables[0].Rows[0]["DateForStr"];
                    Session["CurrencyName"] = ds.Tables[0].Rows[0]["Symbol"];
                    Session["FKCurrencyID"] = ds.Tables[0].Rows[0]["PKCurrencyID"];

                    Response.Redirect("Users/SettingAccount.aspx");

                }
                else
                {
                    diverror.Visible = true;
                    diverror.InnerHtml = Convert.ToString(ds.Tables[0].Rows[0]["Msg"]);
                }
            }
            else
            {
                diverror.Visible = true;
                diverror.InnerHtml = "Invalid Username or Password!";
            }
        }
    }
}