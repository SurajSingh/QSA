using BL.Master;
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
    public partial class Announcements : System.Web.UI.Page
    {
        public string PageVersion = "22062022";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.Announcements, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.Announcements).ToString();
            }
            if (Request.QueryString["PKID"] != null)
            {
                HidID.Value = Request.QueryString["PKID"].ToString();
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PKID,bool ForRead)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Announcements, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();
                bool ForDisplay = false;
                if(!ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Announcements, ClsRoles.IsAdd))
                {
                    ForDisplay = true;

                }

                DataSet ds = objda.GetAnnouncement(PKID, ForDisplay, ForRead, Convert.ToInt64(HttpContext.Current.Session["UserID"]),Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, string Title, object DisplayDate, string Announcement, string ActiveStatus)
        {
            string result = "";
            int status = 1;
            if (Title == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Announcements, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();

                DisplayDate = (DateTime.ParseExact(DisplayDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));


                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Announcements;
                DataSet dsResult = objda.InsertAnnouncement(PKID, Title, DisplayDate,Announcement,ActiveStatus, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Announcements, ClsRoles.IsDelete))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();


                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Announcements;
                DataSet dsResult = objda.DeleteAnnouncement(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}