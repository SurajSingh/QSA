using BLGeneral;
using System;
using System.Data;
using BL.Master;

namespace QuickStartAdmin
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        blUser objda = new blUser();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Session.Abandon();
            }
        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (txtLoginID.Text != "")
            {
                DataSet ds = new DataSet();
               
                objda.LoginID = txtLoginID.Text;
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();

                ds = objda.GetUserByID();
                ProcessForgotPassword(ds);

            }


        }

        void ProcessForgotPassword(DataSet ds)
        {
            if (ds.Tables[0].Rows.Count > 0)
            {
                if (Convert.ToInt32(ds.Tables[0].Rows[0]["Result"]) == 1)
                {
                    //send email to user with the reset password link
                    divforgotpassword.Visible = false;
                    divnotify.Visible = true;
                    divnotify.InnerHtml = "An reset link is send to your registered emailID.";
                    //Response.Redirect("Users/SettingAccount.aspx");
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
                diverror.InnerHtml = "User not Registered!";
            }
        }
    }
}