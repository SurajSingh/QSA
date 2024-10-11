using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;
using BL.Master;
using BLGeneral;
using BL.Appointment;
using System.Web.Http.Results;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using QuickStartAdmin.Classes;
using System.Globalization;
using System.Reflection;
using System.Web;

namespace QuickStartAdmin.Appointment
{
    public partial class Default : System.Web.UI.Page
    {

        int CompanyID = -1;
        
       
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {

                if (Request.QueryString["company"] != null)
                {
                    blCompany objda = new blCompany();
                    DataSet ds = new DataSet();

                    objda.CompanyID = Request.QueryString["company"].ToString();
                    ds = objda.GetCompanybyId();
                    if (ds.Tables[0].Rows.Count == 0)
                    {
                        Response.Redirect("error.html");
                    }
                    else
                    {
                        CompanyID = int.Parse(ds.Tables[0].Rows[0]["PKCompanyID"].ToString());

                        this.Page.Title = ds.Tables[0].Rows[0]["companyname"].ToString();
                        litcompanyname.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                        litcompanyname2.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                        ((Literal)this.Master.FindControl("litcompanyname3")).Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                        ((HtmlImage)this.Master.FindControl("imglogo")).Src = "../webfile/" + ds.Tables[0].Rows[0]["logoURL"].ToString();
                        // = "../webfile/" + ds.Tables[0].Rows[0]["logoURL"].ToString();
                        app_hid_company.Value = ds.Tables[0].Rows[0]["PKCompanyID"].ToString();
                    }

                }
                else
                {
                    string strcompanyid = getsubdomain(Request.Url);
                    blCompany objda = new blCompany();
                    DataSet ds = new DataSet();

                    objda.CompanyID = strcompanyid;
                    ds = objda.GetCompanybyId();
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        CompanyID = int.Parse(ds.Tables[0].Rows[0]["PKCompanyID"].ToString());

                        this.Page.Title = ds.Tables[0].Rows[0]["companyname"].ToString();
                        litcompanyname.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                        litcompanyname2.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                        ((Literal)this.Master.FindControl("litcompanyname3")).Text = ds.Tables[0].Rows[0]["companyname"].ToString();

                        ((HtmlImage)this.Master.FindControl("imglogo")).Src = "../webfile/" + ds.Tables[0].Rows[0]["logoURL"].ToString();
                        //((HtmlImage)this.Master.FindControl("imglogo")).Src = "../images/HCLLP-Logo.png";
                        app_hid_company.Value = ds.Tables[0].Rows[0]["PKCompanyID"].ToString();

                    }
                    else
                    {
                        Response.Redirect("error.html");
                    }

                }
                fillemp(CompanyID);
            }
        }

        private string getsubdomain(System.Uri url)
        {
            string host = url.Host;
            int index = host.IndexOf(".");
            if (host.Split('.').Length > 1)
            {
                return host.Substring(0, index);
            }
            return "";
        }


        public void fillemp(int pCompanyID)
        {           
            blGetMaster objda = new blGetMaster();
            ClsGeneral objgen = new ClsGeneral();

            DataSet ds = objda.GetEmpForAutoComplate(0, "ForAppointment", pCompanyID);
            dropcontactperson.DataSource = ds;
            dropcontactperson.DataTextField = "label1";
            dropcontactperson.DataValueField = "PKID";
            dropcontactperson.DataBind();

            dropcontactperson.Items.Insert(0, new ListItem("-Select--", ""));
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getEmpAvailabilitybyid(string nid)
        {
            blAppointment objda = new blAppointment();
            ClsGeneral objgen = new ClsGeneral();
            
            string msg = "failure";

            try
            {
                DataSet ds = objda.ManageAvailability(int.Parse(nid));
                msg = objgen.SerializeToJSON(ds.Tables[0]);
                return msg;
            }
            catch { return msg; }


        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getEmpAvailability(int empid)
        {

                string msg = "failure";
                blAppointment objda = new blAppointment();
                ClsGeneral objgen = new ClsGeneral();

            try
            {
                    object onDate = ClsGeneral.GetLocalDate();

                    DataSet ds = objda.GetAvailability(empid,onDate);
                    msg = ds.Tables[0].Rows[0][0].ToString();
                    return msg;
                }
                catch { return msg; }

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saveEmpAvailability(string sloatid,string empid,string aDate, string frmTime, string ToTime, string vName, string designation, string company, string email, string contactno,string service,string servicecompanyid)
        {
            string msg = "failure";
            ClsGeneral objgen = new ClsGeneral();
            DataSet ds = new DataSet();
            blAppointment objda = new blAppointment();

            try
            {
                DateTime timetotime = new DateTime();

                string totime;
                int CompanyID = int.Parse(servicecompanyid);
                timetotime = Convert.ToDateTime(aDate.Replace("T00:00:00","") + " " + frmTime);
                timetotime = timetotime.AddHours(1);

                totime = timetotime.ToString(@"HH:mm", new System.Globalization.CultureInfo("en-US")).ToLower();

                string fromtime;
                timetotime = Convert.ToDateTime(aDate.Replace("T00:00:00", "") + " " + frmTime);

                fromtime = timetotime.ToString(@"HH:mm", new System.Globalization.CultureInfo("en-US")).ToLower();


                object onDate = Convert.ToDateTime(aDate);


                objda.FKUserID = int.Parse(empid);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.ViewAppointments;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();

                DataSet dsResult = objda.InsertAppointment(0, int.Parse(empid), int.Parse(sloatid), onDate, fromtime, totime, vName, company, email, contactno, string.Format("Schedule meeting with {0} for {1} service", vName, service), "Confirmed", CompanyID);
                string result = objgen.SerializeToJSON(dsResult.Tables[0]);

                if (dsResult.Tables[0].Rows.Count > 0 && Convert.ToInt64(dsResult.Tables[0].Rows[0]["Result"]) == 1 && Convert.ToString(dsResult.Tables[0].Rows[0]["ApproveStatus"]) == "Confirmed")
                {
                    ClsSMSEmail ObjSend = new ClsSMSEmail();
                    msg = ObjSend.SendAppointmentEmail(Convert.ToInt64(dsResult.Tables[0].Rows[0]["PKID"]), CompanyID, "new", (Int64)ClsPages.SMSEmailLocation.Appointment, Convert.ToInt64(empid), (Int64)ClsPages.WebPages.Appointments);
                    if (msg != "1")
                    {
                        msg = @"[{""Result"":""0"",""Msg"":""" + msg + @"""}]";
                    }

                }
                else if (Convert.ToInt64(dsResult.Tables[0].Rows[0]["Result"]) == 0)
                {
                    msg = @"{""Result"":""0"",""Msg"":""" + dsResult.Tables[0].Rows[0]["Msg"].ToString() + @"""}"; ;
                }

                return msg;
            }
            catch { return msg;  }
        }
    }
}
