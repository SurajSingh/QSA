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
    public partial class Clients : System.Web.UI.Page
    {
        public string PageVersion = "15092022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.Clients, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.Clients).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.Clients).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }


        


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, Int64 PKID, string ActiveStatus, string ClientName)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Clients, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetClient(PageSize, OffSet, SortBy, SortDir, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), ClientName, ActiveStatus);

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, Int64 FKManagerID, string Code, string Company, string CPerson, string CPersonTitle, string ActiveStatus, string Address1, string Address2, Int64 FKTahsilID, Int64 FKCityID, Int64 FKStateID, Int64 FKCountryID, string ZIP, string EMailID, string Phone1, string Phone2, string Mobile, string Fax, string Website, string PWD)
        {
            string result = "";
            int status = 1;
            if (Code == "" || Company == "" || ActiveStatus == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Clients, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Clients;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();

                DataSet dsResult = objda.InsertClient(PKID, FKManagerID, Code, Company, CPerson, CPersonTitle, ActiveStatus, Address1, Address2, FKTahsilID, FKCityID, FKStateID, FKCountryID, ZIP, EMailID, Phone1, Phone2, Mobile, Fax, Website, PWD, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Clients, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Clients;
                DataSet dsResult = objda.DeleteClient(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}