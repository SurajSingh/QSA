using BL.Master;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace QuickStartAdmin.Users
{
    public partial class ProfilePicture : System.Web.UI.Page
    {
        public string PageVersion = "21062022";
      
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.ProfilePicture, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ProfilePicture).ToString();
            }
          
        }





        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProfilePicture, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();
                objda.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                DataSet ds = objda.GetCompany();

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(string RecType,string LogoURL)
        {
            string result = "";
            int status = 1;
            
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProfilePicture,ClsRoles.IsAdd))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();

                objda.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ProfilePicture;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                objda.LogoURL = LogoURL;
                DataSet dsResult = objda.UploadCompanyLogo(RecType);
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
        
    }
}