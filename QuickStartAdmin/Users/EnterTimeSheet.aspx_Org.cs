using BL.Timesheet;
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
    public partial class EnterTimeSheet : System.Web.UI.Page
    {
        public string PageVersion = "12042022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.EnterTimeSheet, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.EnterTimeSheet).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }




        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, string daterange, string FromDate, string ToDate, string FKEmpID, string FKProjectID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EnterTimeSheet, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blTimesheet objda = new blTimesheet();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                if (!ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ApproveTimeSheet, ClsRoles.IsView))
                {
                    FKEmpID = Convert.ToString(HttpContext.Current.Session["UserID"]);
                }


                DataSet ds = objda.GetTimesheet(PageSize, OffSet, SortBy, SortDir, dresult.DateWise, dresult.fromdate, dresult.todate, 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID, "", FKProjectID, "", "", "", 0, 0, 0, "");

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 FKEmpID, Int64 FKManagerID, string SubmitType, string ApproveAction, string ApproveRemark, string dtItemStr)
        {
            string result = "";
            int status = 1;
            if (dtItemStr == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (ApproveAction == "Submit")
                {

                    if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EnterTimeSheet, ""))
                    {
                        status = 0;
                        result = ClsLogin.GetErrorMsg("IL");
                    }
                }
                else
                {
                    if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ApproveTimeSheet, ""))
                    {
                        status = 0;
                        result = ClsLogin.GetErrorMsg("IL");
                    }
                }


            }
            if (status == 1)
            {
                if (ApproveAction == "Submit" && !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ApproveTimeSheet, ""))
                {
                    FKEmpID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);

                }

            }


            if (status == 1)
            {
                blTimesheet objda = new blTimesheet();
                ClsGeneral objgen = new ClsGeneral();
                DataSet dsItem = new DataSet();

                if (dtItemStr != "")
                {
                    DataTable dtItem = objgen.DeserializeTooDataTable(dtItemStr);

                    DataTable dtItemNew = new DataTable();

                    foreach (DataColumn dc in dtItem.Columns)
                    {
                        if (dc.ColumnName == "TaskDate")
                        {
                            dtItemNew.Columns.Add(new DataColumn(dc.ColumnName, typeof(object)));
                        }
                        else
                        {
                            dtItemNew.Columns.Add(new DataColumn(dc.ColumnName, dc.DataType));
                        }


                    }
                    dtItemNew.AcceptChanges();
                    foreach (DataRow dr in dtItem.Rows)
                    {
                        DataRow drNew = dtItemNew.NewRow();
                        foreach (DataColumn dc in dtItem.Columns)
                        {
                            if (dc.ColumnName == "TaskDate")
                            {
                                if (Convert.ToString(dr[dc.ColumnName]) == "")
                                {
                                    drNew[dc.ColumnName] = DBNull.Value;
                                }
                                else
                                {
                                    drNew[dc.ColumnName] = DateTime.ParseExact(Convert.ToString(dr[dc.ColumnName]), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture);

                                }

                            }
                            else
                            {
                                drNew[dc.ColumnName] = dr[dc.ColumnName];

                            }
                        }

                        dtItemNew.Rows.Add(drNew);
                    }
                    dtItemNew.TableName = "Detail";
                    dtItemNew.AcceptChanges();
                    dsItem.Tables.Add(dtItemNew);
                    dsItem.AcceptChanges();
                }               

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.EnterTimeSheet;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet dsResult = objda.InsertTimesheet(FKEmpID, FKManagerID, SubmitType,ApproveAction, ApproveRemark,"",0,dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

      
    }
}