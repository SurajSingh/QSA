using BL.Master;
using BL.Timesheet;
using BLGeneral;
using iTextSharp.text.pdf;
using QuickStartAdmin.Users.RDLC.DataSets;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.NetworkInformation;
using System.Runtime.Remoting;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using static iTextSharp.text.pdf.AcroFields;

namespace QuickStartAdmin.API
{
    public class tsFilter
    {
        public string Projectcode { get; set; }
        public string Taskcode { get; set; }
        public string TaskName { get; set; }
        public string TaskDate { get; set; }
        public string EmpID { get; set; }
    }

    public class tsUpdateHours
    {
        public float hours { get; set; }
    }

    public class tsPost
    {
        public float hours { get; set; }
        public string Projectcode { get; set; }
        public string Taskcode { get; set; }
        public string TaskName { get; set; }
        public string TaskDate { get; set; }

        public string LoginID { get; set; }


        public string SubmitType { get; set; }
        public string ApproveAction { get; set; }
        public string ApproveRemark { get; set; }
        public string TaskStatus { get; set; }

        public string EmpID { get; set; }
        public int CompanyID { get; set; }
        public int ProjectID { get; set; }
        public int TaskID { get; set; }
        public int ManagerID { get; set; }
        public string TaskDescription { get; set; }

        public Boolean IsBillable { get; set; }
        public decimal TBHours { get; set; }
        public decimal TCostRate { get; set; }
        public decimal TBillRate { get; set; }

    }

    public class tsEntry
    {
        public int PKID { get; set; }
        public float hours { get; set; }
        public string Projectcode { get; set; }
        public string Taskcode { get; set; }
        public string TaskName { get; set; }
        public string TaskDate { get; set; }

        public string LoginID { get; set; }
        public int EmpID { get; set; }
    }

    public class tsTask
    {
        public string TaskCode { get; set; }
        public string TaskName { get; set; }

        public string Description { get; set; }
    }

    public class tsClient
    {
        public string ProjectCode { get; set; }

        public string ProjectName { get; set; }
    }


    [RoutePrefix("api/timesheet")]
    public class TimesheetController : ApiController
    {

        // POST: api/timesheet/updatehours/5
        [ActionName("updatehours")]
        [HttpPost]
        public HttpResponseMessage updatehours(int id, [FromBody] tsUpdateHours tsHours)
        {

            blTimesheet objda = new blTimesheet();
            HttpStatusCode httpStatusCode = HttpStatusCode.OK;
            string errMessage = "";
            if (id > 0)
            {
                try
                {
                    objda.UpdateTimesheetEntryHours(id, tsHours.hours);
                }
                catch (Exception e)
                {
                    errMessage = e.Message;
                    httpStatusCode = HttpStatusCode.InternalServerError;
                }
            }
            else
            {
                httpStatusCode = HttpStatusCode.BadRequest;
            }
            return (errMessage != "") ? Request.CreateResponse<string>(httpStatusCode, errMessage) : Request.CreateResponse(httpStatusCode);
        }

        // POST: api/Timesheet/get
        [Route("get")]
        [HttpPost]
        public HttpResponseMessage Get([FromBody] tsFilter pFilter)
        {
            DataSet ds = new DataSet();
            tsEntry loEntry = new tsEntry();
            blTimesheet objda = new blTimesheet();
            HttpStatusCode httpStatusCode = HttpStatusCode.OK;
            if (pFilter.Taskcode.Trim() != "" && pFilter.Projectcode.Trim() != "")
            {
                try
                {
                    int EmployeeID = -1;
                    if (string.IsNullOrEmpty(pFilter.EmpID.Trim()))
                    {
                        EmployeeID = -1;
                    }
                    else
                    {
                        EmployeeID = Convert.ToInt32(pFilter.EmpID);
                    }
                    ds = objda.GetTimesheet(pFilter.Projectcode, pFilter.Taskcode, pFilter.TaskName, pFilter.TaskDate, EmployeeID);

                    if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {

                        loEntry.PKID = Convert.ToInt32(ds.Tables[0].Rows[0]["PKID"]);
                        loEntry.hours = (float)Convert.ToDecimal(ds.Tables[0].Rows[0]["Hrs"]);
                        loEntry.Taskcode = pFilter.Taskcode;
                        loEntry.Projectcode = pFilter.Projectcode;
                        loEntry.TaskName = pFilter.TaskName;
                        loEntry.TaskDate = pFilter.TaskDate;
                        loEntry.LoginID = (string)ds.Tables[0].Rows[0]["LoginID"];
                        loEntry.EmpID = Convert.ToInt32(ds.Tables[0].Rows[0]["FKEmpID"]);

                    }
                    else
                    {
                        httpStatusCode = HttpStatusCode.NotFound;
                    }
                }
                catch (Exception e)
                {
                    httpStatusCode = HttpStatusCode.InternalServerError;
                }

            }
            else
            {
                httpStatusCode = HttpStatusCode.BadRequest;
            }

            return Request.CreateResponse<tsEntry>(httpStatusCode, loEntry);
        }

        // POST: api/Timesheet/clientcodeswithtask
        [Route("getclientcodes")]
        [HttpGet]
        public HttpResponseMessage GetClientCodes()
        {
            DataSet ds = new DataSet();
            List<tsClient> tsClients = new List<tsClient>();
            blTimesheet objda = new blTimesheet();
            HttpStatusCode httpStatusCode = HttpStatusCode.OK;

            try
            {
                ds = objda.GetClientCodes();

                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow r in ds.Tables[0].Rows)
                    {
                        tsClient loClient = new tsClient();
                        loClient.ProjectCode = r["projectCode"].ToString();
                        loClient.ProjectName = r["projectName"].ToString();


                        tsClients.Add(loClient);
                    }
                }
                else
                {
                    httpStatusCode = HttpStatusCode.NotFound;
                }
            }
            catch (Exception e)
            {
                httpStatusCode = HttpStatusCode.InternalServerError;
            }

            //}
            //else
            //{
            //    httpStatusCode = HttpStatusCode.BadRequest;
            //}

            return Request.CreateResponse<List<tsClient>>(httpStatusCode, tsClients);
        }

        [Route("gettaskcodes")]
        [HttpGet]
        public HttpResponseMessage GetTaskCodes()
        {
            DataSet ds = new DataSet();
            List<tsTask> tsTasks = new List<tsTask>();
            blTimesheet objda = new blTimesheet();
            HttpStatusCode httpStatusCode = HttpStatusCode.OK;

            try
            {
                ds = objda.GetTaskCodes();

                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow r in ds.Tables[0].Rows)
                    {
                        tsTask loTask = new tsTask();

                        loTask.TaskCode = r["TaskCode"].ToString();
                        loTask.TaskName = r["TaskName"].ToString();
                        loTask.Description = r["Description"].ToString();

                        tsTasks.Add(loTask);

                    }

                }
                else
                {
                    httpStatusCode = HttpStatusCode.NotFound;
                }
            }
            catch (Exception e)
            {
                httpStatusCode = HttpStatusCode.InternalServerError;
            }

            //}
            //else
            //{
            //    httpStatusCode = HttpStatusCode.BadRequest;
            //}

            return Request.CreateResponse<List<tsTask>>(httpStatusCode, tsTasks);
        }

        [Route("post")]
        [HttpPost]
        public HttpResponseMessage Post([FromBody] tsPost tsPost)
        {
            blTimesheet objda = new blTimesheet();

            blUser objUser = new blUser(); //user (GetUserByID)
            blMaster objMaster = new blMaster(); //task and project

            DataSet ds = new DataSet();
            DataSet dsResult = new DataSet();
            DataSet dsUser = new DataSet();
            DataSet dsTask = new DataSet();
            DataSet dsProject = new DataSet();

            HttpStatusCode httpStatusCode = HttpStatusCode.OK;
            string errMessage = "";
            try
            {
                int EmployeeID = -1;
                if (string.IsNullOrEmpty(tsPost.EmpID))
                {
                    EmployeeID = -1;
                }
                else
                {
                    EmployeeID = Convert.ToInt32(tsPost.EmpID);
                }
                //sanity check: if a entry with the same task code, task name, project code, date exist
                ds = objda.GetTimesheet(tsPost.Projectcode, tsPost.Taskcode, tsPost.TaskName, tsPost.TaskDate, EmployeeID);

                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    //update the hours
                    objda.UpdateTimesheetEntryHours(Convert.ToInt32(ds.Tables[0].Rows[0]["PKID"]), tsPost.hours);
                    dsResult = objda.GetTimesheet(tsPost.Projectcode, tsPost.Taskcode, tsPost.TaskName, tsPost.TaskDate, EmployeeID);

                }
                else
                {
                    //get the emp details from LoginID
                    dsUser = objUser.GetUserByID(tsPost.LoginID);

                    //check if user exist
                    if (dsUser.Tables.Count > 0 && dsUser.Tables[0].Rows.Count <= 0)
                    {
                        throw new Exception("Login Id does not exist");
                    }

                    //get the emp details from EmpID
                    if (EmployeeID != -1)
                    {
                        objUser = new blUser();
                        objUser.PKUserID = EmployeeID;
                        DataSet dsvalidateUser = objUser.ValidateUserID();

                        //check if user exist
                        if (dsvalidateUser.Tables.Count >= 0 && dsvalidateUser.Tables[0].Rows.Count > 0 && dsvalidateUser.Tables[0].Rows[0]["Result"].ToString() == "0")
                        {
                            throw new Exception("Emp Id does not exist");
                        }
                    }

                    //get Task details from TaskName and Task code
                    dsTask = objMaster.GetTaskByFilter(tsPost.Taskcode, tsPost.TaskName);

                    //check if task exist
                    if (dsTask.Tables.Count > 0 && dsTask.Tables[0].Rows.Count <= 0)
                    {
                        throw new Exception("Task does not exist");
                    }

                    //get the project details from project code
                    dsProject = objMaster.GetProjectByFilter(tsPost.Projectcode);

                    //check if project exist
                    if (dsProject.Tables.Count > 0 && dsProject.Tables[0].Rows.Count <= 0)
                    {
                        throw new Exception("Project does not exist");
                    }

                    //get companyID, ManagerID from Users table
                    DataRow drUser = dsUser.Tables[0].Rows[0];
                    if (EmployeeID != -1)
                    {
                        tsPost.EmpID = EmployeeID.ToString();

                    }
                    else
                    {
                        tsPost.EmpID = drUser["PKUserID"].ToString();
                    }

                    tsPost.CompanyID = Convert.ToInt32(drUser["FKCompanyID"]);
                    tsPost.ManagerID = drUser["FKManagerID"] == DBNull.Value ? 0 : Convert.ToInt32(drUser["FKManagerID"]);

                    //get the task description, taskid, isbillable, TBHours, TCostRate, TBillRate
                    DataRow drTask = dsTask.Tables[0].Rows[0];
                    tsPost.TaskID = Convert.ToInt32(drTask["PKID"]);
                    tsPost.TaskDescription = drTask["Description"] + "";
                    tsPost.IsBillable = Convert.ToBoolean(drTask["IsBillable"]);
                    tsPost.TBHours = Convert.ToDecimal(drTask["BHours"]);
                    tsPost.TCostRate = Convert.ToDecimal(drTask["CostRate"]);
                    tsPost.TBillRate = Convert.ToDecimal(drTask["BillRate"]);

                    //get the project id
                    DataRow drProject = dsProject.Tables[0].Rows[0];
                    tsPost.ProjectID = Convert.ToInt32(drProject["PKID"]);

                    tsPost.SubmitType = "PM";
                    tsPost.ApproveAction = "Submit";
                    tsPost.ApproveRemark = "";
                    tsPost.TaskStatus = "pending";

                    object dsItem = GetPostXML(tsPost);


                    objda.FKUserID = Convert.ToInt32(tsPost.EmpID);
                    objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                    objda.FKPageID = (Int64)ClsPages.WebPages.EnterTimeSheet;
                    objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                    dsResult = objda.InsertTimesheet(Convert.ToInt32(tsPost.EmpID), tsPost.ManagerID, tsPost.SubmitType, tsPost.ApproveAction, tsPost.ApproveRemark, tsPost.TaskStatus, 0, dsItem, tsPost.CompanyID);
                    //objda.UpdateTimesheetEntryHours(Convert.ToInt32(dsResult.Tables[0].Rows[0]["PKID"]), tsPost.hours);
                }

            }
            catch (Exception e)
            {
                errMessage = e.Message;
                httpStatusCode = HttpStatusCode.InternalServerError;
            }

            return (errMessage != "") ? Request.CreateResponse<string>(httpStatusCode, errMessage) : Request.CreateResponse<DataSet>(httpStatusCode, dsResult);
        }

        private string GetPostXML(tsPost postItem)
        {
            DataSet dsItem = new DataSet();

            DataTable dtItem = new DataTable();

            dtItem.Columns.Add(new DataColumn("PKID", typeof(int)));
            dtItem.Columns.Add(new DataColumn("TaskDate", typeof(DateTime)));
            dtItem.Columns.Add(new DataColumn("FKTaskID", typeof(int)));
            dtItem.Columns.Add(new DataColumn("FKProjectID", typeof(int)));
            dtItem.Columns.Add(new DataColumn("Hrs", typeof(decimal)));
            dtItem.Columns.Add(new DataColumn("Description", typeof(string)));
            dtItem.Columns.Add(new DataColumn("IsBillable", typeof(bool)));
            dtItem.Columns.Add(new DataColumn("Memo", typeof(string)));
            dtItem.Columns.Add(new DataColumn("TBHours", typeof(decimal)));
            dtItem.Columns.Add(new DataColumn("TCostRate", typeof(decimal)));
            dtItem.Columns.Add(new DataColumn("TBillRate", typeof(decimal)));
            //dtItem.Columns.Add(new DataColumn("FKSubmitToID", typeof(int)));
            dtItem.Columns.Add(new DataColumn("ModeForm", typeof(int)));

            dtItem.AcceptChanges();

            DataRow drNew = dtItem.NewRow();

            drNew["PKID"] = 0;
            drNew["TaskDate"] = DateTime.Parse(postItem.TaskDate);
            drNew["FKTaskID"] = postItem.TaskID;
            drNew["FKProjectID"] = postItem.ProjectID;
            drNew["Hrs"] = postItem.hours;
            drNew["Description"] = postItem.TaskDescription;
            drNew["IsBillable"] = postItem.IsBillable;
            drNew["Memo"] = "";
            drNew["TBHours"] = postItem.TBHours;
            drNew["TCostRate"] = postItem.TCostRate;
            drNew["TBillRate"] = postItem.TBillRate;
            //drNew["FKSubmitToID"] = DBNull.Value;
            drNew["ModeForm"] = 0;


            dtItem.Rows.Add(drNew);

            dtItem.TableName = "Detail";
            dtItem.AcceptChanges();

            dsItem.Tables.Add(dtItem);
            dsItem.AcceptChanges();

            return dsItem.GetXml();
        }

        protected override void Dispose(bool disposing)
        {
            //db.Dispose();
            base.Dispose(disposing);
        }

    }
}