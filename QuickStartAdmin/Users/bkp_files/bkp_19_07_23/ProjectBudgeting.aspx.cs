using BL.Master;
using BL.ProjectManagement;
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
    public partial class ProjectBudgeting : System.Web.UI.Page
    {
        public string PageVersion = "15082022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.ProjectBudgeting, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ProjectBudgeting).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.ProjectBudgeting).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetBudgetForAutoComplete(Int64 FKProjectID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProjectBudgeting, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blProjectManagement objda = new blProjectManagement();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetBudgetForAutoComplete(FKProjectID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, Int64 PKID, Int64 FKProjectID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProjectBudgeting, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blProjectManagement objda = new blProjectManagement();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetProjectBudget(PageSize, OffSet, SortBy, SortDir, PKID, FKProjectID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, string BudgetTitle, object FromDate, object ToDate, Int64 FKProjectID, string dtItemStr)
        {
            string result = "";
            int status = 1;
            if (dtItemStr == "" || FKProjectID==0 || BudgetTitle == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProjectBudgeting, ""))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }


            }
            

            if (status == 1)
            {
                if (Convert.ToString(FromDate) == "")
                {
                    FromDate = null;
                }
                else
                {
                    FromDate = (DateTime.ParseExact(FromDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }
                if (Convert.ToString(ToDate) == "")
                {
                    ToDate = null;
                }
                else
                {
                    ToDate = (DateTime.ParseExact(ToDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }
                blProjectManagement objda = new blProjectManagement();
                ClsGeneral objgen = new ClsGeneral();
                DataSet dsItem = new DataSet();

                DataTable dtItem = objgen.DeserializeTooDataTable(dtItemStr);

                dtItem.TableName = "Detail";
                dtItem.AcceptChanges();
                dsItem.Tables.Add(dtItem);
                dsItem.AcceptChanges();


                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ProjectBudgeting;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet dsResult = objda.InsertProductBudget(PKID,BudgetTitle,FromDate,ToDate,FKProjectID, dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ProjectBudgeting, ClsRoles.IsDelete))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blProjectManagement objda = new blProjectManagement();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ProjectBudgeting;
                DataSet dsResult = objda.DeleteProjectBudget(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}