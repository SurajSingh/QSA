using BL;
using BL.Master;
using BL.Payroll;
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
    public partial class LeaveSettings : System.Web.UI.Page
    {
        public string PageVersion = "17052022";
        public string StrCurrency = "$";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.LeaveSettings, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.LeaveSettings).ToString();
            }


            if (ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.LeaveSettings, ClsRoles.IsAdd))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.LeaveSettings).ToString();
            }
            else
            {
                Response.Redirect("Dashboard.aspx");
            }
        }





        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.LeaveSettings, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetPayrollSetting(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKID, string StartMonth, string EndMonth, string LeaveRule, string dtItemStr, string dtWorkingDaysStr)
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
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.LeaveSettings, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }


            }

            if (status == 1)
            {
                blPayroll objda = new blPayroll();
                ClsGeneral objgen = new ClsGeneral();
                DataSet dsItem = new DataSet();

                if (dtItemStr != "")
                {
                    DataTable dtItem = objgen.DeserializeTooDataTable(dtItemStr);
                    dtItem.TableName = "Leave";
                    dtItem.AcceptChanges();
                    dsItem.Tables.Add(dtItem);
                    dsItem.AcceptChanges();
                }
                if (dtWorkingDaysStr != "")
                {
                    DataTable dtItem = objgen.DeserializeTooDataTable(dtWorkingDaysStr);

                    DataTable dtItemNew = new DataTable();

                    foreach (DataColumn dc in dtItem.Columns)
                    {
                        if (dc.ColumnName == "StartTime" || dc.ColumnName == "EndTime")
                        {
                            dtItemNew.Columns.Add(new DataColumn(dc.ColumnName, typeof(string)));
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
                            if (dc.ColumnName == "StartTime" || dc.ColumnName == "EndTime")
                            {
                                if (Convert.ToString(dr[dc.ColumnName]) == "")
                                {
                                    drNew[dc.ColumnName] = DBNull.Value;
                                }
                                else
                                {
                                    DateTime dateTime = DateTime.ParseExact(Convert.ToString(dr[dc.ColumnName]), "hh:mm tt", CultureInfo.InvariantCulture);
                                    object FromTime = dateTime.TimeOfDay;
                                    drNew[dc.ColumnName] = FromTime.ToString();

                                }

                            }
                            else
                            {
                                drNew[dc.ColumnName] = dr[dc.ColumnName];

                            }
                        }

                        dtItemNew.Rows.Add(drNew);
                    }
                    dtItemNew.TableName = "WeekDays";
                    dtItemNew.AcceptChanges();
                    dsItem.Tables.Add(dtItemNew);
                    dsItem.AcceptChanges();

                    string strTimeError = "";
                    foreach (DataRow dr in dsItem.Tables["WeekDays"].Rows)
                    {

                        if (dr["StartTime"] != DBNull.Value && dr["EndTime"] != DBNull.Value)
                        {
                            if (Convert.ToDateTime(dr["StartTime"]) > Convert.ToDateTime(dr["EndTime"]))
                            {

                                status = 0;
                                strTimeError += "Start time is greater then End Time in " + objgen.WeekDayNameByNumber(Convert.ToInt32(dr["DayNum"]))+"<br/>";
                              
                            }
                            else if (Convert.ToDateTime(dr["StartTime"]) == Convert.ToDateTime(dr["EndTime"]))
                            {
                                status = 0;
                                strTimeError += "Start Time is and End Time is same in " + objgen.WeekDayNameByNumber(Convert.ToInt32(dr["DayNum"])) + "<br/>";
                                
                            }

                        }


                    }

                    if (status == 0)
                    {
                        result = @"[{""Result"":""0"",""Msg"":""" + strTimeError + @"""}]";
                    }
                }



                if (status == 1)
                {
                    objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                    objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                    objda.FKPageID = (Int64)ClsPages.WebPages.LeaveSettings;
                    objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                    DataSet dsResult = objda.InsertPayrollSetting(PKID, StartMonth, EndMonth, LeaveRule, dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                    result = objgen.SerializeToJSON(dsResult.Tables[0]);
                }

            }

            return result;

        }


    }
}