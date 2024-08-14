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
    public partial class SetTableLayout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["PageID"] == null || Request.QueryString["GridName"] == null)
            {
                Response.Redirect("BadRequest.aspx");
            }
            if (ClsLogin.ValidateRole(Convert.ToInt32(Request.QueryString["URID"]), ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = Convert.ToString(Request.QueryString["PageID"]);
                HidGridName.Value = Convert.ToString(Request.QueryString["GridName"]);
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = Convert.ToString(Request.QueryString["URID"]);
            }
            else
            {
                Response.Redirect("PageInvalidRequest.aspx");

            }
        }
      
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 FKPageID, string GridName, string XMLDef,bool ForAllUser)
        {
            string result = "";
            int status = 1;
            if (XMLDef == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin())
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();

                DataSet dsData = new DataSet();
                DataTable dtHeader = objgen.DeserializeTooDataTable(XMLDef);
                dsData.Tables.Add(dtHeader);
                dsData.AcceptChanges();
               
                DataSet dsResult = objda.InsertTableLayout(FKPageID, GridName, dsData.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]), Convert.ToInt64(HttpContext.Current.Session["UserID"]), ForAllUser,false);
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string ResetData(Int64 FKPageID, string GridName,bool ForAllUser)
        {
            string result = "";
            int status = 1;
          
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin())
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();

                DataSet dsData = new DataSet();
               

                DataSet dsResult = objda.InsertTableLayout(FKPageID, GridName, dsData.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]), Convert.ToInt64(HttpContext.Current.Session["UserID"]), ForAllUser, true);
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

     
    }
}