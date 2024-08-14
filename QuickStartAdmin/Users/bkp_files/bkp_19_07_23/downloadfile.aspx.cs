using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class downloadfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!ClsLogin.ValidateLogin())
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>window.close();</script>", false);
                return;
            }
            if (Request.QueryString["fid"] == null || Request.QueryString["fid1"] == null || Request.QueryString["rectype"] == null)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>window.close();</script>", false);
                return;
            }
            else
            {
                ClsCommon objCommon = new ClsCommon();
                if (objCommon.DownloadVirturalFile(Request.QueryString["fid"].ToString(), Request.QueryString["fid1"].ToString(), AppDomain.CurrentDomain.BaseDirectory + "\\webfiles\\transaction\\"))
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>window.close();</script>", false);
                }

            }
        }
    }
}