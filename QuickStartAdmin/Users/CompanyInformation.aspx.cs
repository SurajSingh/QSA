using BL.Master;
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
    public partial class CompanyInformation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.CompanyInformation, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = Convert.ToString(HttpContext.Current.Session["OrgID"]);

            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.CompanyInformation, ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blCompany objda = new blCompany();
                ClsGeneral objgen = new ClsGeneral();
                objda.PKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                DataSet ds = objda.GetCompany();
                ds.AcceptChanges();
                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(string CompanyID, string CompanyName, string Address1, string Address2, Int64 FKTahsilID, Int64 FKCityID, Int64 FKStateID, Int64 FKCountryID, string ZIP, string Mobile, string Phone, string Email, string CPerson, string CPersonTitle, string GSTNo, string PANNo, string LogoURL, string Website, Int64 FKTimezoneID, Int64 FKCurrencyID, string DateForStr)
        {
            string result = "";
            int status = 1;
            if ( CompanyName == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.CompanyInformation, ClsRoles.IsEdit))
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
                objda.CompanyID = CompanyID;
                objda.CompanyName = CompanyName;
                objda.Address1 = Address1;
                objda.Address2 = Address2;
                objda.FKTahsilID = FKTahsilID;
                objda.FKCityID = FKCityID;
                objda.FKStateID = FKStateID;
                objda.FKCountryID = FKCountryID;
                objda.ZIP = ZIP;
                objda.Mobile = Mobile;
                objda.Phone = Phone;
                objda.Email = Email;
                objda.CPerson = CPerson;
                objda.CPersonTitle = CPersonTitle;
                objda.GSTNo = GSTNo;
                objda.PANNo = PANNo;
                objda.LogoURL = LogoURL;
                objda.Website = Website;
                objda.FKTimezoneID = FKTimezoneID;
                objda.FKCurrencyID = FKCurrencyID;
                objda.DateForStr = DateForStr;

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.CompanyInformation;

                DataSet dsResult = objda.UpdateCompany();
                if (dsResult.Tables[0].Rows[0]["Result"].ToString() == "1")
                {
                    HttpContext.Current.Session["DateFormat"] = DateForStr;
                }

                //Added By Nilesh For Currency Change Task -Start(Reason - To update the session value)
                HttpContext.Current.Session["OrgName"] = CompanyName;
                HttpContext.Current.Session["DateFormat"] = DateForStr;
                //HttpContext.Current.Session["CurrencyName"] = dsResult.Tables[0].Rows[0]["CurrencySymbol"];
                HttpContext.Current.Session["FKCurrencyID"] = FKCurrencyID;
                //Added By Nilesh For Currency Change Task - End

                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }


    }
}