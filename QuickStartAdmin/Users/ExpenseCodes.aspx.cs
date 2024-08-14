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
    public partial class ExpenseCodes : System.Web.UI.Page
    {
        public string PageVersion = "14082022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.ExpenseCodes, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ExpenseCodes).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.ExpenseCodes).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }


      



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, Int64 PKID, string ActiveStatus, string TaskCode, Int64 FKDeptID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ExpenseCodes, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetTaskMaster(PageSize, OffSet, SortBy, SortDir, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), TaskCode, FKDeptID, "E", ActiveStatus);

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, string TaskCode, string TaskName, string Description, bool IsBillable, string ActiveStatus, Int64 FKDeptID, decimal CostRate, decimal BillRate, string TEType, decimal Tax, decimal BHours, bool isReimb, decimal MuRate)
        {
            string result = "";
            int status = 1;
            if (TaskCode == "" || TaskName == "" || ActiveStatus == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ExpenseCodes, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
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
                objda.FKPageID = (Int64)ClsPages.WebPages.ExpenseCodes;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();

                DataSet dsResult = objda.InsertTaskMaster(PKID, TaskCode, TaskName, Description, IsBillable, ActiveStatus, FKDeptID, CostRate, BillRate, TEType, Tax, BHours, isReimb, MuRate, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ExpenseCodes, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ExpenseCodes;
                DataSet dsResult = objda.DeleteTaskMaster(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}