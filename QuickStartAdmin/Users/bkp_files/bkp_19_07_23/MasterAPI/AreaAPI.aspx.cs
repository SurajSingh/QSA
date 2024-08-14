using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.Master;

namespace QuickStartAdmin.Users.MasterAPI
{
    public partial class AreaAPI : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetAllCountry()
        {

            string result = "";
            if (ClsLogin.ValidateLogin())
            {
                blMaster objda = new blMaster();
                DataSet ds = new DataSet();
                ClsGeneral objgen = new ClsGeneral();
                ds = objda.GetCountry(0);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    result = objgen.SerializeToJSON(ds.Tables[0]);
                }
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetAllState(Int64 FKCountryID)
        {

            string result = "";
            if (ClsLogin.ValidateLogin())
            {
                blMaster objda = new blMaster();
                DataSet ds = new DataSet();
                ClsGeneral objgen = new ClsGeneral();
                
                ds = objda.GetState(FKCountryID,0);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    result = objgen.SerializeToJSON(ds.Tables[0]);
                }
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetAllCity(Int64 FKStateID)
        {

            string result = "";
            if (ClsLogin.ValidateLogin())
            {
                blMaster objda = new blMaster();
                DataSet ds = new DataSet();
                ClsGeneral objgen = new ClsGeneral();
               
                ds = objda.GetCity(FKStateID,0);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    result = objgen.SerializeToJSON(ds.Tables[0]);
                }
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetTahsil(Int64 FKCityID)
        {

            string result = "";
            if (ClsLogin.ValidateLogin())
            {
                blMaster objda = new blMaster();
                DataSet ds = new DataSet();
                ClsGeneral objgen = new ClsGeneral();

                ds = objda.GetTahsil(FKCityID,0);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    result = objgen.SerializeToJSON(ds.Tables[0]);
                }
            }

            return result;
        }

    }
}