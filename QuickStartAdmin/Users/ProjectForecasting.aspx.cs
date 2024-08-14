using BL.Master;
using BL.ProjectManagement;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Data;
using System.Globalization;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class ProjectForecasting : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.ProjectForecasting, ""))
            {

                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ProjectForecasting).ToString();

            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PKID,Int64 FKProjectID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProjectForecasting, ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blProjectManagement objda = new blProjectManagement();
                ClsGeneral objgen = new ClsGeneral();
               
                DataSet ds = objda.GetProjectModule(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]),0,FKProjectID,"");
                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, Int64 FKProjectID, string ModuleName, string ModuleDesc, Int64 FKParentID, Int64 FKTaskID, object EstStartDate, object EstEndDate, decimal EstHrs, decimal CompletePer, string TaskStatus, string RecType)
        {
            string result = "";
            bool Status = true;
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProjectForecasting, ClsRoles.IsAdd))
            {

                result = ClsLogin.GetErrorMsg("IO");
                Status = false;
            }
            if (Status) {
                if (Convert.ToString(EstStartDate) == "")
                {
                    EstStartDate = null;
                }
                else
                {
                    EstStartDate = (DateTime.ParseExact(EstStartDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }
                if (Convert.ToString(EstEndDate) == "")
                {
                    EstEndDate = null;
                }
                else
                {
                    EstEndDate = (DateTime.ParseExact(EstEndDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }

                


            }
            if (Status) {

                blProjectManagement objda = new blProjectManagement();
                ClsGeneral objgen = new ClsGeneral();

                



                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ProjectForecasting;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet ds = objda.InsertProjectModule(PKID, FKProjectID, ModuleName, ModuleDesc, FKParentID, FKTaskID, EstStartDate, EstEndDate, EstHrs, CompletePer, TaskStatus, RecType, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProjectForecasting, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blProjectManagement objda = new blProjectManagement();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ProjectForecasting;
                DataSet dsResult = objda.DeleteProjectModule(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}