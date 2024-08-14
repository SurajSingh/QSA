using BL.Master;
using BLGeneral;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        blUser objda = new blUser();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //check if the token is provided
                Session.Abandon();
                ValidateResetPwdToken();
            }
        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (txtNewPassword.Text != "")
            {
                string _ResetPwdToken = (String.IsNullOrEmpty(Request.QueryString["token"]) == false) ? Request.QueryString["token"] : "";
                DataSet ds = new DataSet();

                objda.PWDNew = txtNewPassword.Text;
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();

                ProcessResetPassword(_ResetPwdToken);

            }


        }
        void ValidateResetPwdToken()
        {

            string _ResetPwdToken = (String.IsNullOrEmpty(Request.QueryString["token"]) == false) ? Request.QueryString["token"] : "";

            //check if the token is valid
            if (_ResetPwdToken != "")
            {
                DataSet ds = new DataSet();
                ds = objda.ValidateResetPasswordToken(_ResetPwdToken);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (Convert.ToInt32(ds.Tables[0].Rows[0]["Result"]) == 1)
                    {
                        divresetpassword.Visible = true;
                        divnotify.Visible = false;
                    }
                    else
                    {
                        divresetpassword.Visible = false;
                        divnotify.Visible = true;
                        divnotify.InnerHtml = "Invalid token.";
                    }
                }
            }
            else
            {
                divresetpassword.Visible = false;
                divnotify.Visible = true;
                divnotify.InnerHtml = "Invalid token.";
            }
        }

        void ProcessResetPassword(string ResetPwdToken)
        {
            DataSet ds = new DataSet();
            ds = objda.ResetPassword(ResetPwdToken);

            if (ds.Tables[0].Rows.Count > 0)
            {
                if (Convert.ToInt32(ds.Tables[0].Rows[0]["Result"]) == 1)
                {
                    Response.Redirect("Login.aspx");
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
                diverror.InnerHtml = "Reset password failed. Try after sometime. If the problem persist contact Admin.";
            }
        }
    }
}