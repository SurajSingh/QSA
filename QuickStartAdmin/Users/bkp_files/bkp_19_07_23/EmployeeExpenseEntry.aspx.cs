using BL.Timesheet;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Data;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class EmployeeExpenseEntry : System.Web.UI.Page
    {
        public string PageVersion = "12042022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.EmployeeExpenseEntry, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.EmployeeExpenseEntry).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }




        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, string daterange, string FromDate, string ToDate, string FKEmpID, string FKProjectID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EmployeeExpenseEntry, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blTimesheet objda = new blTimesheet();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                if (!ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ApproveEmployeeExpenses, ClsRoles.IsView))
                {
                    FKEmpID = Convert.ToString(HttpContext.Current.Session["UserID"]);
                }


                DataSet ds = objda.GetExpensesLog(PageSize, OffSet, SortBy, SortDir, dresult.DateWise, dresult.fromdate, dresult.todate, 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID, "", FKProjectID, "", "", "", "", 0, "");

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 FKEmpID, string ApproveAction, string ApproveRemark, string dtItemStr, string StrDeletedFiles)
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

                    if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EmployeeExpenseEntry, ""))
                    {
                        status = 0;
                        result = ClsLogin.GetErrorMsg("IL");
                    }
                }
                else
                {
                    if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ApproveEmployeeExpenses, ""))
                    {
                        status = 0;
                        result = ClsLogin.GetErrorMsg("IL");
                    }
                }


            }
            if (status == 1)
            {
                if (ApproveAction == "Submit" && !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ApproveEmployeeExpenses, ""))
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
                objda.FKPageID = (Int64)ClsPages.WebPages.EmployeeExpenseEntry;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet dsResult = objda.InsertExpensesLog(FKEmpID, ApproveAction, ApproveRemark, dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                if (Convert.ToInt64(dsResult.Tables[0].Rows[0]["Result"]) == 1)
                {

                    if (StrDeletedFiles != "")
                    {
                        string[] arrfile = StrDeletedFiles.Split(',');
                        for (int i = 0; i < arrfile.Length; i++)
                        {
                            if (arrfile[i] != "")
                            {
                                string path = AppDomain.CurrentDomain.BaseDirectory + "\\webfiles\\transaction\\" + arrfile[i];
                                if (File.Exists(path))
                                {
                                    try
                                    {
                                        File.Delete(path);
                                    }
                                    catch { }
                                }
                            }
                        }
                    }
                }

                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }


    }
}