using BL.Master;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin
{
    public partial class ResetPasswordByEmailSend : System.Web.UI.Page
    {
        int userId = 0;
        blUser objda = new blUser();
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
                userId = Convert.ToInt32(Request.QueryString["id"]);

            DataSet ds = new DataSet();
            if (txtNewPassword.Text != "")
            {
                objda.PKUserID = userId;
                objda.PWDNew = txtNewPassword.Text;
            }
            ds = objda.ResetPasswordByPKUserId();
            if (ds.Tables[0].Rows.Count > 0)
            {
                int result = Convert.ToInt32(ds.Tables[0].Rows[0]["Result"]);
                string message = ds.Tables[0].Rows[0]["Msg"].ToString();

                if (result == 1)
                {
                    divresetpassword.Visible = false;
                    divnotify.Visible = true;
                    SqlMsgDiv.Visible = true;  

                    SqlMsgDiv.InnerHtml = HttpUtility.HtmlEncode(message);
                }
                else
                {
                    divresetpassword.Visible = false;
                    divnotify.Visible = true;
                    SqlMsgDiv.Visible = true;  

                    SqlMsgDiv.InnerHtml = HttpUtility.HtmlEncode(message);
                }
            }
            else
            {
                diverror.Visible = true;
                diverror.InnerHtml = "Reset password failed.";
            }
        }
    }
}