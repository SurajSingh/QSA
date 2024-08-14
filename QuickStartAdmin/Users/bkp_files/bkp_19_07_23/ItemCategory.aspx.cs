using BL.Asset;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Data;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class ItemCategory : System.Web.UI.Page
    {
        public string PageVersion = "07032022";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.AssetCategory, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.AssetCategory).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.Employees).ToString();

            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.AssetCategory, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();


                DataSet ds = objda.GetAssetCategory(PKID, "", Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, string Code,string Name,string CategDesc)
        {
            string result = "";
            int status = 1;
            if (Code == "" || Name=="")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.AssetCategory, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.AssetCategory;
                DataSet dsResult = objda.InsertAssetCategory(PKID, Code, Name,CategDesc, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.AssetCategory, ClsRoles.IsDelete))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();


                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.AssetCategory;
                DataSet dsResult = objda.DeleteAssetCategory(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}