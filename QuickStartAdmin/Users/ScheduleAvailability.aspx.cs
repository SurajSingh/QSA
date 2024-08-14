using BL.Appointment;
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
    public partial class ScheduleAvailability : System.Web.UI.Page
    {
        public string PageVersion = "17052022";
      
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.ScheduleAvailability, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ScheduleAvailability).ToString();
            }


            if (ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ScheduleAvailability, ClsRoles.IsAdd))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.ScheduleAvailability).ToString();
            }
            else
            {
                Response.Redirect("Dashboard.aspx");
            }
        }





        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(string daterange, string FromDate, string ToDate, Int64 FKEmpID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ScheduleAvailability, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blAppointment objda = new blAppointment();
                ClsGeneral objgen = new ClsGeneral();
                var dresult = DateRange.getLastDates(daterange, FromDate, ToDate, Convert.ToString(HttpContext.Current.Session["DateFormat"]));
                DataSet ds = objda.GetAppointmentAvailability(dresult.DateWise, dresult.fromdate, dresult.todate,0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]),FKEmpID,"");

                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 FKEmpID, string dtItemStr)
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
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.ScheduleAvailability, ClsRoles.IsAdd))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }


            }

            if (status == 1)
            {
                blAppointment objda = new blAppointment();
                ClsGeneral objgen = new ClsGeneral();
                DataSet dsItem = new DataSet();

                
                if (dtItemStr != "")
                {
                    DataTable dtItem = objgen.DeserializeTooDataTable(dtItemStr);

                    DataTable dtItemNew = new DataTable();

                    foreach (DataColumn dc in dtItem.Columns)
                    {
                        if (dc.ColumnName == "FromTime" || dc.ColumnName == "ToTime")
                        {
                            dtItemNew.Columns.Add(new DataColumn(dc.ColumnName, typeof(string)));
                        }
                        else if (dc.ColumnName == "OnDate")
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
                            if (dc.ColumnName == "FromTime" || dc.ColumnName == "ToTime")
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
                            else if (dc.ColumnName == "OnDate")
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
                objda.FKPageID = (Int64)ClsPages.WebPages.ScheduleAvailability;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                DataSet dsResult = objda.InsertAppointmentAvailability(FKEmpID, dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));

                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }


    }
}