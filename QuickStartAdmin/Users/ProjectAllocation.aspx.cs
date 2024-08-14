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
    public partial class ProjectAllocation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.ProjectAllocation, ""))
            {

                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ProjectAllocation).ToString();

            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PKID, Int64 FKProjectID,Int64 FKParentID,string RecType)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProjectAllocation, ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blProjectManagement objda = new blProjectManagement();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetProjectModule(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKParentID, FKProjectID, RecType);
                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, Int64 FKEmpID, Int64 FKManagerID, object AssignDate)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProjectAllocation, ClsRoles.IsAdd))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blProjectManagement objda = new blProjectManagement();
                ClsGeneral objgen = new ClsGeneral();

                if (Convert.ToString(AssignDate) == "")
                {
                    AssignDate = null;
                }
                else
                {
                    AssignDate = (DateTime.ParseExact(AssignDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }
                


                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ProjectAllocation;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet ds = objda.AssignProjectModule(PKID, FKEmpID, FKManagerID,AssignDate, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string UpdateModuleStatus(Int64 PKID, string NewStatus, object NewDate, Int64 CompletePer)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProjectAllocation, ClsRoles.IsAdd))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blProjectManagement objda = new blProjectManagement();
                ClsGeneral objgen = new ClsGeneral();

                if (Convert.ToString(NewDate) == "")
                {
                    NewDate = null;
                }
                else
                {
                    NewDate = (DateTime.ParseExact(NewDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }



                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ProjectAllocation;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet ds = objda.UpdateModuleStatus(PKID, NewStatus, NewDate, CompletePer, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }


    }
}