using BL.Master;
using BL.Timesheet;
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
    public partial class EmployeeTaskAssignment : System.Web.UI.Page
    {
        public string PageVersion = "1204202202";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.EmployeeTaskAssignment, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.EmployeeTaskAssignment).ToString();
            }
            StrCurrency = Session["CurrencyName"].ToString();
        }





        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, string daterange, string FromDate, string ToDate, Int64 PKID, string FKEmpID, string FKProjectID,string FKClientID,string FKTaskID,string CurrentStatus,Int64 FKManagerID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EmployeeTaskAssignment, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blTimesheet objda = new blTimesheet();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));

                if (!ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EmployeeTaskAssignment, ClsRoles.IsAdd))
                {
                    FKEmpID = Convert.ToString(HttpContext.Current.Session["UserID"]);
                }


                DataSet ds = objda.GetTaskAssignment(PageSize, OffSet, SortBy, SortDir, dresult.DateWise, dresult.fromdate, dresult.todate, PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID,FKClientID, FKProjectID, FKTaskID,CurrentStatus, FKManagerID,"");

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 FKEmpID, Int64 FKManagerID, string dtItemStr)
        {
            string result = "";
            int status = 1;
            if (dtItemStr == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EmployeeTaskAssignment, ClsRoles.IsAdd))
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("IL");
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
                        if (dc.ColumnName == "AssignDate")
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
                            if (dc.ColumnName == "AssignDate")
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
                objda.FKPageID = (Int64)ClsPages.WebPages.EmployeeTaskAssignment;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet dsResult = objda.InsertTaskAssignment(FKEmpID, FKManagerID, dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EmployeeTaskAssignment, ClsRoles.IsDelete))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blTimesheet objda = new blTimesheet();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.EmployeeTaskAssignment;
                DataSet dsResult = objda.DeleteTaskAssignment(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }



      
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveTimeSheetData(Int64 FKEmpID, Int64 FKManagerID, string SubmitType, string ApproveAction, string ApproveRemark, string TaskStatus, Int64 FKAssignLogID, string dtItemStr)
        {
            string result = "";
            int status = 1;
            if (dtItemStr == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }

            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EnterTimeSheet, ""))
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("IL");
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
                objda.FKPageID = (Int64)ClsPages.WebPages.EmployeeTaskAssignment;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet dsResult = objda.InsertTimesheet(FKEmpID, FKManagerID, SubmitType, ApproveAction, ApproveRemark, TaskStatus, FKAssignLogID, dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteAssignmentLog(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EmployeeTaskAssignment, ClsRoles.IsDelete))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blTimesheet objda = new blTimesheet();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.EmployeeTaskAssignment;
                DataSet dsResult = objda.DeleteAssignmentLog(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

    }
}