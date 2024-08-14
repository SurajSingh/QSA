using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace QuickStartAdmin.Classes
{
    public class ClsLogin
    {
        public static bool ValidateLogin()
        {
            if (HttpContext.Current.Session["OrgID"] == null || HttpContext.Current.Session["OrgName"] == null || HttpContext.Current.Session["PhotoURL"] == null ||  HttpContext.Current.Session["Name"] == null || HttpContext.Current.Session["UserID"] == null || HttpContext.Current.Session["RoleType"] == null || HttpContext.Current.Session["DateFormat"] == null || HttpContext.Current.Session["CurrencyName"] == null || HttpContext.Current.Session["FKCurrencyID"] == null || HttpContext.Current.Session["OrgType"] == null|| HttpContext.Current.Session["RoleTable"] == null || HttpContext.Current.Session["PageTable"] == null)
            {
                return false;
            }
            else
            {
                return true;
            }

        }
        public static string SettingBranch()
        {
            string result = "";
            if (HttpContext.Current.Session["OrgID"] == null || HttpContext.Current.Session["OrgName"] == null || HttpContext.Current.Session["PhotoURL"] == null || HttpContext.Current.Session["Name"] == null || HttpContext.Current.Session["UserID"] == null || HttpContext.Current.Session["RoleType"] == null || HttpContext.Current.Session["OrgType"] == null)
            {

            }
            else
            {
                BL.Master.blUser objlogin = new BL.Master.blUser();

                objlogin.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objlogin.RoleType = Convert.ToString(HttpContext.Current.Session["RoleType"]);                
                DataSet ds = objlogin.GetUserRoleAndPages();


                HttpContext.Current.Session["RoleTable"] = ds.Tables[0];
                HttpContext.Current.Session["PageTable"] = ds.Tables[1];
               
              
               

                result = @"[{""Result"":""" + 1 + @""",""BranchID"":""" +0 + @"""}]";
            }


            return result;
        }

        public static string SettingDashboardLinks()
        {
            string result = "";
            BL.Master.blUser objlogin = new BL.Master.blUser();

            objlogin.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
            objlogin.FKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
            objlogin.RoleType = Convert.ToString(HttpContext.Current.Session["RoleType"]);
            DataSet ds = objlogin.GetUserDashboardLink();

            if (ds.Tables[0].Rows.Count > 0)
            {

                foreach(DataRow dr in ds.Tables[0].Rows)
                {
                    result += @" <div class='col-md-6 col-xl-3'><div class='card'><div class='card-body dashboardlinks'><div class='float-end mt-2'>"+Convert.ToString(dr["IconHTML"])+@"</i></div>
                    <div><h4 class='mb-1 mt-1'><span data-plugin='counterup'>"+ Convert.ToString(dr["LinkName"]) + @"</span></h4><p class='linkdesc'><a href='"+ Convert.ToString(dr["LinkURL"]) + @"'>"+ Convert.ToString(dr["LinkDescription"]) + @"</a></p>
                                        </div></div> </div></div>";
                }
            }


           


            return result;
        }

        public static bool ValidateRole(Int32 FKRoleID, string Role)
        {
            bool status = true;
            string StrFilter = "FKRoleID=" + FKRoleID;
            if (Role != "")
            {
                StrFilter = StrFilter + " And " + Role + "=1";
            }
            DataRow[] Dr = ((DataTable)HttpContext.Current.Session["RoleTable"]).Select(StrFilter);
            if (Dr.Length == 0)
            {
                status = false;
            }
            return status;
        }
        public static bool ValidateRedirect(Int32 FKRoleID, string Role)
        {
            bool status = true;
            if (!ValidateLogin())
            {
                status = false;
                HttpContext.Current.Response.Redirect("/Users/Logout.aspx");

            }
            else
            {
                if (!ValidateRole(FKRoleID, Role))
                {
                    status = false;
                    HttpContext.Current.Response.Redirect("/Users/Dashboard.aspx");
                }
            }

            return status;
        }
        public static string GetErrorMsg(string MsgType)
        {
            Int64 Result = 0;
            string StrMsg = "Invalid Operation";
            switch (MsgType)
            {
                case "IL":
                    Result = 9;
                    StrMsg = "Session out, please login again";
                    break;
                case "IO":
                    StrMsg = "Invalid Operation";
                    break;

                case "V":
                    StrMsg = "Please fill required fields!";
                    break;

                case "EmptyCart":
                    StrMsg = "No Items in Cart";
                    break;

            }
            return @"[{""Result"":"""+ Result + @""",""Msg"":""" + StrMsg + @"""}]";
        }
        public static string GetErrorMsg(Int32 Result, string Msg)
        {

            return @"[{""Result"":""" + Result + @""",""Msg"":""" + Msg + @"""}]";
        }
        public static string GetRequestIP()
        {
            string userip = HttpContext.Current.Request.UserHostAddress;
            return userip;
        }
    }
}