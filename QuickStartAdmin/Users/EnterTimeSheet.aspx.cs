using BL.Asset;
using BL.Master;
using BL.Timesheet;
using BLGeneral;
using Hangfire.Storage;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Org.BouncyCastle.Asn1.Pkcs;
using Org.BouncyCastle.Asn1.X509.Qualified;
using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.DynamicData;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.UI.WebControls;
namespace QuickStartAdmin.Users
{
    public partial class EnterTimeSheet : System.Web.UI.Page
    {
        public string PageVersion = "12042022";
        public string StrCurrency = "$";
        static blTimesheet objda = new blTimesheet();
        static blMaster blMaster = new blMaster();
        static blUser blUser = new blUser();
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
                DataSet dsResult = objda.InsertTimesheet(FKEmpID, FKManagerID, SubmitType, ApproveAction, ApproveRemark, "", 0, dsItem.GetXml(), Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.EnterTimeSheet, PKID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blTimesheet objda = new blTimesheet();
                ClsGeneral objgen = new ClsGeneral();

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.InvoiceList;
                DataSet dsResult = objda.DeleteTimesheetEntry(PKID, Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string ImportExcel(Int64 FKManagerID, string SubmitType, string ApproveAction, string ApproveRemark, string dtItemStr)
        {
            StringBuilder errorStr = new StringBuilder();
            try
            {
                DataTable dtExcelData = GetExcelData(dtItemStr);
                DataTable dtNewData = GenerateTimeSheetData(dtExcelData, 1, out errorStr);
                if (errorStr.Length == 0)
                {
                    objda.ImportExcel("@ExcelData", dtNewData);
                }
            }
            catch (Exception ex)
            {
                errorStr.Append(ex.Message);
            }
            return errorStr.ToString();

        }

        private static DataTable GetExcelData(string jsonData)
        {
            // Convert JSON array to a JArray object
            JArray jsonArray = JArray.Parse(jsonData);
            // Create DataTable and define columns
            DataTable dataTable = new DataTable();

            // Add columns based on the first array (header)
            foreach (var header in jsonArray[0])
            {
                dataTable.Columns.Add(header.ToString());
            }

            // Add rows skipping the first array (header)
            for (int i = 1; i < jsonArray.Count; i++)
            {
                DataRow row = dataTable.NewRow();
                for (int j = 0; j < jsonArray[i].Count(); j++)
                {
                    row[j] = jsonArray[i][j].ToString();
                }
                dataTable.Rows.Add(row);
            }

            return dataTable;

        }
        private static DataTable GenerateTimeSheetData(DataTable dtExcelData, long FKCompanyID, out StringBuilder errorMsg)
        {
            DataTable dtNew = new DataTable();
            long PkId = 0;
            errorMsg = new StringBuilder();
            dtNew.Columns.Add("PKID", typeof(int));
            dtNew.Columns.Add("TaskDate", typeof(DateTime));
            dtNew.Columns.Add("FKTaskID", typeof(long));
            dtNew.Columns.Add("FKEmpID", typeof(long));
            dtNew.Columns.Add("FKProjectID", typeof(long));
            dtNew.Columns.Add("Hrs", typeof(decimal));
            dtNew.Columns.Add("TBillRate", typeof(decimal));
            dtNew.Columns.Add("Description", typeof(string));
            dtNew.Columns.Add("IsBillable", typeof(bool));
            dtNew.Columns.Add("Memo", typeof(string));
            dtNew.Columns.Add("TCostRate", typeof(decimal));
            dtNew.Columns.Add("FKCompanyID", typeof(long));
            dtNew.Columns.Add("BHours", typeof(decimal));



            var distinctProjectCodes = dtExcelData.AsEnumerable().Select(row => row.Field<string>("Project Code")).Distinct();
            string projectCodes = string.Join(",", distinctProjectCodes);

            var fromDate = dtExcelData.AsEnumerable()
                               .Min(row => row.Field<string>("Date"));
            var toDate = dtExcelData.AsEnumerable()
                               .Max(row => row.Field<string>("Date"));

            DataTable dtProject = GetProjectDetail(projectCodes);
            DataTable dtTasks = GetTaskDetail();

            DataTable dtExistingTimeData = GetExistingTimeSheetData(fromDate, toDate);

            long PKId = 0;

            DataTable dtId = objda.GetNewGeneratedPKID("tblTimeSheet", "PKID");
            if (dtId != null && dtId.Rows.Count > 0)
                PkId = Convert.ToInt64(dtId.Rows[0]["PKID"]);

            foreach (DataRow row in dtExcelData.Rows)
            {
                DataRow dr = dtNew.NewRow();
                string taskDate = row["Date"].ToString() ?? "";
                string taskCodeName = row["Task Code"].ToString() ?? "";
                char[] delimeters = { ':', '-' };
                string[] taskCodeArr = taskCodeName.Split(delimeters);

                string taskCode = taskCodeArr.Length >= 2 ? taskCodeArr[0] : "";
                string taskName = taskCodeArr.Length >= 2 ? taskCodeArr[1] : "";
                string projectCode = row["Project Code"].ToString() ?? "";
                string hrs = row["Hrs"].ToString() ?? "";
                string memo = row["Memo"].ToString() ?? "";
                string loginId = row["LoginID"].ToString() ?? "";
                decimal hours = 0.0m;
                long? userId = 0;
                DataTable dtUser = blUser.GetUserByID(loginId)?.Tables[0];
                if (dtUser != null && dtUser.Rows.Count > 0)
                    userId = Convert.ToInt64(dtUser.Rows[0]["PKUserID"]);

                if (userId == null || userId == 0)
                    errorMsg.Append($"Invalid login id '{loginId}' on {taskDate};<br>");

                long? taskId = dtTasks.AsEnumerable().FirstOrDefault(a => a.Field<string>("TaskCode").Equals(taskCode) && a.Field<string>("TaskName").Equals(taskName))?.Field<long>("PKID");
                if (taskId == null || taskId == 0)
                    errorMsg.Append($"Invalid task code '{taskCode}' on {taskDate};<br>");

                long? projectId = dtProject.AsEnumerable().FirstOrDefault(a => a.Field<string>("ProjectCode").Equals(projectCode) || a.Field<string>("ProjectName").Equals(projectCode))?.Field<long>("PKID");
                if (projectId == null || projectId == 0)
                    errorMsg.Append($"Invalid project code '{projectCode}' on {taskDate};<br>");

                if (string.IsNullOrEmpty(hrs) || !decimal.TryParse(hrs, out hours))
                    errorMsg.Append($"Invalid hours '{hrs}' on {taskDate};<br>");

                if (string.IsNullOrEmpty(errorMsg.ToString()))
                {
                    string description = string.Empty;
                    decimal billRate = 0.0m;
                    decimal costRate = 0.0m;
                    bool isBillable = false;
                    decimal bHours = 0.0m;
                    DataRow drTask = dtTasks.AsEnumerable().FirstOrDefault(a => a.Field<string>("TaskCode").Equals(taskCode) && a.Field<string>("TaskName").Equals(taskName));

                    if (drTask != null)
                    {
                        description = drTask.Field<string>("Description");
                        billRate = drTask.Field<decimal>("BillRate");
                        costRate = drTask.Field<decimal>("CostRate");
                        isBillable = drTask.Field<bool>("IsBillable");
                        bHours = drTask.Field<decimal>("BHours");
                    }
                    dr["PKID"] = PkId += 1;
                    dr["TaskDate"] = taskDate;
                    dr["FKTaskID"] = taskId;
                    dr["FKEmpID"] = userId;
                    dr["FKProjectID"] = projectId;
                    dr["Hrs"] = hours;
                    dr["TBillRate"] = billRate;
                    dr["Description"] = description;
                    dr["IsBillable"] = isBillable;
                    dr["Memo"] = memo;
                    dr["TCostRate"] = costRate;
                    dr["FKCompanyID"] = FKCompanyID;
                    dr["BHours"] = bHours;
                    dtNew.Rows.Add(dr);
                }
            }

            return dtNew;
        }
        private static DataTable GetProjectDetail(string projectCodes)
        {
            DataTable dtProjects = blMaster.GetProjectByCodes(projectCodes)?.Tables[0];
            return dtProjects;
        }
        private static DataTable GetTaskDetail()
        {
            DataTable dtTaskCodes = objda.GetTaskCodes()?.Tables[0];
            return dtTaskCodes;
        }
        private static DataTable GetExistingTimeSheetData(string fromDate, string toDate)
        {
            DataTable existingTimeSheetData = objda.GetTimeSheetByDates(fromDate, toDate)?.Tables[0];
            return existingTimeSheetData;
        }
        //private void OldExcelImportCode()
        //{
        //    //List<List<string>> newArray = JsonConvert.DeserializeObject<List<List<string>>>(dtItemStr);
        //    //var lFirstEle = newArray.First();
        //    //Dictionary<string, int> importHeaderColoumn = new Dictionary<string, int>();
        //    ////Initialize Dictionary
        //    //importHeaderColoumn.Add("loginid", -1);
        //    //importHeaderColoumn.Add("date", -1);
        //    //importHeaderColoumn.Add("projectname", -1);
        //    //importHeaderColoumn.Add("projectcode", -1);
        //    //importHeaderColoumn.Add("taskname", -1);
        //    //importHeaderColoumn.Add("taskcode", -1);
        //    //importHeaderColoumn.Add("hrs", -1);
        //    //importHeaderColoumn.Add("memo", -1);



        //    //int coloumnCount = 0;

        //    //foreach (var ColoumName in lFirstEle)
        //    //{
        //    //    var keyColoumn = ColoumName.ToString().Replace(" ", "").ToLower();
        //    //    if (importHeaderColoumn.ContainsKey(keyColoumn))
        //    //    {
        //    //        importHeaderColoumn[keyColoumn] = coloumnCount;
        //    //    }
        //    //    ++coloumnCount;
        //    //}



        //    //Args tokenArgs = new Args();
        //    //tokenArgs.PKID = 0;

        //    //tokenArgs.ModeForm = 0;



        //    //string result = "";
        //    //int status = 1;


        //    //int count = -1;
        //    //string errorStr = "";

        //    //foreach (var innerList in newArray)
        //    //{
        //    //    count++;
        //    //    if (count == 0) continue;
        //    //    string row = count.ToString();


        //    //    int stopval = -1;

        //    //    //DataSet dsResult = objda.ImportExcelNew();

        //    //    tokenArgs.TaskDate = importHeaderColoumn["date"] != -1 && innerList.Count > importHeaderColoumn["date"] ? (innerList[importHeaderColoumn["date"]] + "").ToString().Trim() : DateTime.Now.ToString("MM/dd/YYYY");
        //    //    tokenArgs.LoginID = importHeaderColoumn["loginid"] != -1 && innerList.Count > importHeaderColoumn["loginid"] ? (innerList[importHeaderColoumn["loginid"]] + "").ToString().Trim() : Convert.ToString(HttpContext.Current.Session["UserID"]); ;
        //    //    tokenArgs.ProjectName = importHeaderColoumn["projectname"] != -1 && innerList.Count > importHeaderColoumn["projectname"] ? (innerList[importHeaderColoumn["projectname"]] + "").ToString().Trim() : "";
        //    //    tokenArgs.ProjectCode = importHeaderColoumn["projectcode"] != -1 && innerList.Count > importHeaderColoumn["projectname"] ? (innerList[importHeaderColoumn["projectcode"]] + "").ToString().Trim() : "";
        //    //    tokenArgs.Taskname = importHeaderColoumn["taskname"] != -1 && innerList.Count > importHeaderColoumn["taskname"] ? (innerList[importHeaderColoumn["taskname"]] + "").ToString().Trim() : "";
        //    //    tokenArgs.TaskCode = importHeaderColoumn["taskcode"] != -1 && innerList.Count > importHeaderColoumn["projectname"] ? (innerList[importHeaderColoumn["taskcode"]] + "").ToString().Trim() : "";
        //    //    tokenArgs.Hrs = importHeaderColoumn["hrs"] != -1 && innerList.Count > importHeaderColoumn["hrs"] ? (innerList[importHeaderColoumn["hrs"]] + "").ToString().Trim() : "0";
        //    //    tokenArgs.memo = importHeaderColoumn["memo"] != -1 && innerList.Count > importHeaderColoumn["memo"] ? "<p>" + (innerList[importHeaderColoumn["memo"]] + "").ToString().Trim() + "</p>" : "";

        //    //    //if (string.IsNullOrEmpty(tokenArgs.Hrs))
        //    //    //{
        //    //    //    errorStr = $"you have entered invalid hours for {tokenArgs.TaskDate}. please check";
        //    //    //    break;
        //    //    //}

        //    //    string jsonString = JsonConvert.SerializeObject(tokenArgs);
        //    //    string jsonArrayString = "[" + jsonString + "]";



        //    //    if (status == 1)
        //    //    {

        //    //        ClsGeneral objgen = new ClsGeneral();
        //    //        DataSet dsItem = new DataSet();

        //    //        if (dtItemStr != "")
        //    //        {
        //    //            DataTable dtItem = objgen.DeserializeTooDataTable(jsonArrayString);

        //    //            DataTable dtItemNew = new DataTable();

        //    //            foreach (DataColumn dc in dtItem.Columns)
        //    //            {
        //    //                if (dc.ColumnName == "TaskDate")
        //    //                {
        //    //                    dtItemNew.Columns.Add(new DataColumn(dc.ColumnName, typeof(object)));
        //    //                }
        //    //                else
        //    //                {
        //    //                    dtItemNew.Columns.Add(new DataColumn(dc.ColumnName, dc.DataType));
        //    //                }


        //    //            }
        //    //            dtItemNew.AcceptChanges();
        //    //            foreach (DataRow dr in dtItem.Rows)
        //    //            {
        //    //                DataRow drNew = dtItemNew.NewRow();
        //    //                foreach (DataColumn dc in dtItem.Columns)
        //    //                {
        //    //                    if (dc.ColumnName == "TaskDate")
        //    //                    {
        //    //                        if (Convert.ToString(dr[dc.ColumnName]) == "")
        //    //                        {
        //    //                            drNew[dc.ColumnName] = DBNull.Value;
        //    //                        }
        //    //                        else
        //    //                        {
        //    //                            try
        //    //                            {
        //    //                                // Code that might throw an exception

        //    //                                drNew[dc.ColumnName] = DateTime.ParseExact(Convert.ToString(dr[dc.ColumnName]), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture);
        //    //                            }
        //    //                            catch
        //    //                            {
        //    //                                stopval = 1;
        //    //                                errorStr += "date format is not correct" + "<br>";

        //    //                            }

        //    //                        }

        //    //                    }
        //    //                    else
        //    //                    {
        //    //                        drNew[dc.ColumnName] = dr[dc.ColumnName];

        //    //                    }
        //    //                }

        //    //                dtItemNew.Rows.Add(drNew);
        //    //            }
        //    //            dtItemNew.TableName = "Detail";
        //    //            dtItemNew.AcceptChanges();
        //    //            dsItem.Tables.Add(dtItemNew);
        //    //            dsItem.AcceptChanges();
        //    //        }
        //    //        if (stopval == 1)
        //    //        {
        //    //            errorStr += "<br>";
        //    //            continue;
        //    //        }
        //    //        objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
        //    //        objda.IPAddress = Classes.ClsLogin.GetRequestIP();
        //    //        objda.FKPageID = (Int64)ClsPages.WebPages.EnterTimeSheet;
        //    //        objda.MACAdd = ClsGeneral.GetRequestMACAddr();
        //    //        DataSet dsResult = objda.ImportExcel(FKManagerID, SubmitType, ApproveAction, ApproveRemark, "", 0, dsItem.GetXml(), 1);
        //    //        result = objgen.SerializeToJSON(dsResult.Tables[0]);

        //    //        string pattern = @"\""Msg\"":\s*\""([^\""]*)\""";

        //    //        Match match = Regex.Match(result, pattern);
        //    //        string extractedData = match.Groups[1].Value;
        //    //        //string removeLastChar = extractedData.Substring(0, extractedData.Length - 2);
        //    //        if (extractedData.Length > 5)
        //    //        {

        //    //            string replacedString = extractedData.Substring(0, extractedData.Length - 2).Replace(",", "<br>" + row + " -->");
        //    //            errorStr += row + " -->" + replacedString + "<br>";

        //    //        }
        //    //        if (errorStr.Length > 0)
        //    //        {

        //    //            errorStr += "<br>";
        //    //        }

        //    //    }
        //    //}
        //}

    }
}