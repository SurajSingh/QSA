using BLGeneral;
using System;
using System.Data;
using BL.Master;
using BLGeneral.Message;
using System.Configuration;

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
                    int id = Convert.ToInt32(ds.Tables[0].Rows[0]["PKUserID"]);
                    string siteUrl = ConfigurationManager.AppSettings["WebURL"];
                    string resetPageUrl = $"{siteUrl}resetpass.aspx?id={id}";
                    string emailTo = "shubhamverma1743@gmail.com"; //ds.Tables[0].Rows[0]["EmailID"].ToString();
                    EmailData emailData = new EmailData
                    {
                        SenderEmail = ConfigurationManager.AppSettings["SenderMail"],
                        SenderPWD = ConfigurationManager.AppSettings["SenderPass"],
                        SMTPServer = ConfigurationManager.AppSettings["MailHost"],
                        SMTPPort = Convert.ToInt32(ConfigurationManager.AppSettings["SenderPort"]),
                        EnableSSL = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSSL"]),
                        To = emailTo,
                        Subject = "Password Reset Request",
                        Message = $"Please click the following link to reset your password: {resetPageUrl}"
                    };

                    string result = ClsSendSMSEmail.SendEmailAsync(emailData);
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