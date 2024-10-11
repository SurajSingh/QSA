using BL.Asset;
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

namespace QuickStartAdmin.Users.MasterAPI
{
    public partial class MasterPageAPI : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetUserInRole(Int64 FKRoleID)
        {

            string result = "";
            if (ClsLogin.ValidateLogin())
            {
                string StrFilter = "FKRoleID=" + FKRoleID;
               
                DataRow[] Dr = ((DataTable)HttpContext.Current.Session["RoleTable"]).Select(StrFilter);
                
                if (Dr.Length == 0)
                {

                    result = @"[{""RoleType"":""" + Convert.ToString(HttpContext.Current.Session["UserType"]) + @""",""IsView"":" + 0 + @",""IsAdd"":" + 0 + @",""IsEdit"":" + 0 + @",""IsDelete"":" + 0 + @",""OrgType"":""" + HttpContext.Current.Session["OrgType"].ToString() + @"""}]";
                }
                else
                {

                    result = @"[{""RoleType"":""" + Convert.ToString(HttpContext.Current.Session["UserType"]) + @""",""IsView"":" + Convert.ToInt32(Dr[0]["IsView"]) + @",""IsAdd"":" + Convert.ToInt32(Dr[0]["IsAdd"]) + @",""IsEdit"":" + Convert.ToInt32(Dr[0]["IsEdit"]) + @",""IsDelete"":" + Convert.ToInt32(Dr[0]["IsDelete"]) + @",""OrgType"":""" + HttpContext.Current.Session["OrgType"].ToString() + @"""}]";

                }

            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetUserInRoles(string StrRoleID)
        {

            string result = "";
            if (ClsLogin.ValidateLogin())
            {

                string[] ArrRole = StrRoleID.Split(',');
                for (int i = 0; i < ArrRole.Length; i++)
                {
                    if (ArrRole[i] != "")
                    {
                        string StrFilter = "FKRoleID=" + ArrRole[i];
                        DataRow[] Dr = ((DataTable)HttpContext.Current.Session["RoleTable"]).Select(StrFilter);
                        if (result != "")
                        {
                            result = result + ",";
                        }
                        if (Dr.Length == 0)
                        {
                            result += @"{""FKRoleID"":" + ArrRole[i] + @",""IsFound"":" + 0 + @"}";
                        }
                        else
                        {
                            result += @"{""FKRoleID"":" + ArrRole[i] + @",""IsFound"":" + 1 + @"}";
                        }
                    }
                }
                result = "[" + result + "]";

            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetPageForAutoAcomplete()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                // result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                ClsGeneral objgen = new ClsGeneral();
                DataRow[] drPage = ((DataTable)HttpContext.Current.Session["PageTable"]).Select("PageLink<>''");
                DataTable dtNewPage = new DataTable();
                dtNewPage.Columns.Add("PKID");
                dtNewPage.Columns.Add("label");
                dtNewPage.Columns.Add("label1");
                foreach (DataRow dr in drPage)
                {
                    DataRow drNewRow = dtNewPage.NewRow();
                    drNewRow["PKID"] = dr["PageLink"];
                    drNewRow["label"] = "<div class='col-md-2'>" + Convert.ToInt64(dr["PKPageID"]) + "</div><div class='col-md-4'>" + Convert.ToString(dr["PageName"]) + "</div>";
                    drNewRow["label1"] = dr["PageName"];
                    dtNewPage.Rows.Add(drNewRow);
                }
                dtNewPage.AcceptChanges();
                result = objgen.SerializeToJSON(dtNewPage);

            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetNotification()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();
               

                DataSet ds = objda.GetNotification(Convert.ToInt64(HttpContext.Current.Session["UserID"]), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                
                if(ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Announcements, ClsRoles.IsView))
                {
                    ds.Tables[2].Rows[0]["IsAnnouncement"] = true;
                }
                if (ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Schedule, ClsRoles.IsView))
                {
                    ds.Tables[3].Rows[0]["IsSchedue"] = true;
                }
                ds.AcceptChanges();
                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetTimeZone()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetTimezoneID();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetCurrency()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetCurrency();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }
       

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetTableLayout(Int64 FKPageID, string TableID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetTableLayout(FKPageID, TableID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), Convert.ToInt64(HttpContext.Current.Session["UserID"]));
                if (ds.Tables.Count > 0)
                {
                    result = objgen.SerializeToJSON(ds.Tables[0]);
                }
                else
                {
                    result = "[]";

                }

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetBillingFrequency()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetBillingFrequency();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetContractType()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetContractType();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }



        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetPaymentModeMaster()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetPaymentModeMaster();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetPaymentTypeMaster()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetPaymentTypeMaster();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetTaxMaster()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetTaxMaster(100,0,"","D",0,"", Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetPaymentTerm()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetPaymentTerm(0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetEmpForAutoComplate(Int64 PKID, string ActiveStatus)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blGetMaster objda = new blGetMaster();
                ClsGeneral objgen = new ClsGeneral();

                if (Convert.ToString(HttpContext.Current.Session["RoleType"]) != "Admin")
                {
                    PKID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                }

                DataSet ds = objda.GetEmpForAutoComplate(PKID, ActiveStatus, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                if (ds.Tables.Count > 0)
                {
                    result = objgen.SerializeToJSON(ds.Tables[0]);
                }
                else
                {
                    result = "[]";

                }

            }
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetClientForAutoComplete(Int64 PKID, string ActiveStatus)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blGetMaster objda = new blGetMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetClientForAutoComplete(PKID, ActiveStatus, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                if (ds.Tables.Count > 0)
                {
                    result = objgen.SerializeToJSON(ds.Tables[0]);
                }
                else
                {
                    result = "[]";

                }

            }
            return result;
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetProjectForAutoComplete(Int64 PKID, string ActiveStatus,Int64 FKClientID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blGetMaster objda = new blGetMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetProjectForAutoComplete(PKID, ActiveStatus, FKClientID,Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                if (ds.Tables.Count > 0)
                {
                    result = objgen.SerializeToJSON(ds.Tables[0]);
                }
                else
                {
                    result = "[]";

                }

            }
            return result;
        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetTaskForAutoComplete(Int64 PKID, Int64 FKDeptID,string TType, string ActiveStatus)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blGetMaster objda = new blGetMaster();
                ClsGeneral objgen = new ClsGeneral();
                DataSet ds = objda.GetTaskForAutoComplete(PKID, FKDeptID, TType, ActiveStatus, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                if (ds.Tables.Count > 0)
                {
                    result = objgen.SerializeToJSON(ds.Tables[0]);
                }
                else
                {
                    result = "[]";

                }

            }
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetDepartment()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();


                DataSet ds = objda.GetDepartment(100, 0, "", "D", 0, "", Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetLocationMaster()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetLocationMaster();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetAssetConditionMaster()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetAssetConditionMaster();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetAssetCategory()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetAssetCategory(0,"", Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetParty()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetParty(0,0,"","",0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]),"");
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetAssetForAutoComplete()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin())
            {

                result = "";
            }
            else
            {
                blAsset objda = new blAsset();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetAssetForAutoComplete(0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
    }
}