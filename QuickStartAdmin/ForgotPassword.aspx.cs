using BLGeneral;
using System;
using System.Data;
using BL.Master;
using BLGeneral.Message;
using System.Configuration;
using QuickStartAdmin.Users;

namespace QuickStartAdmin
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        blUser objda = new blUser();
        blCompany objfb = new blCompany();
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
                    objfb.PKCompanyID = 1;
                    DataSet dsEmailSetting = objfb.GetEmailSettings();

                    int id = Convert.ToInt32(ds.Tables[0].Rows[0]["PKUserID"]);
                    string siteUrl = ConfigurationManager.AppSettings["WebURL"];
                    string resetPageUrl = $"{siteUrl}resetpass.aspx?id={id}";
                    string emailTo = ds.Tables[0].Rows[0]["EmailID"].ToString();
                    EmailData emailData = new EmailData
                    {
                        SenderEmail = Convert.ToString(dsEmailSetting.Tables[0].Rows[0]["SenderEmail"]), //ConfigurationManager.AppSettings["SenderMail"],
                        SenderPWD = Convert.ToString(dsEmailSetting.Tables[0].Rows[0]["SenderPWD"]),
                        SMTPServer = Convert.ToString(dsEmailSetting.Tables[0].Rows[0]["SMTPServer"]),
                        SMTPPort = Convert.ToInt32(dsEmailSetting.Tables[0].Rows[0]["SMTPPort"]),
                        EnableSSL = Convert.ToBoolean(dsEmailSetting.Tables[0].Rows[0]["EnableSSL"]),
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