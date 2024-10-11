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

namespace QuickStartAdmin.Appointment
{
    public partial class Default : System.Web.UI.Page
    {
        //clsLogin objlogin = new clsLogin();
        DataSet ds = new DataSet();
       
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {





                //    if(Request.QueryString["company"]!=null)
                //    {
                //        ClsAdmin objda = new ClsAdmin();

                //        objda.code=Request.QueryString["company"].ToString();
                //        ds = objda.getCompanybyCode();
                //        if (ds.Tables[0].Rows.Count == 0)
                //        {
                //            Response.Redirect("error.html");
                //        }
                //        else
                //        {
                //            this.Page.Title = ds.Tables[0].Rows[0]["companyname"].ToString();
                //            litcompanyname.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                //            litcompanyname2.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                //            ((Literal)this.Master.FindControl("litcompanyname3")).Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                //            ((HtmlImage)this.Master.FindControl("imglogo")).Src = "../images/HCLLP-Logo.png";
                //                // = "../webfile/" + ds.Tables[0].Rows[0]["logoURL"].ToString();
                //            app_hid_company.Value = ds.Tables[0].Rows[0]["nid"].ToString();
                //        }

                //    }
                //    else
                //    {
                //        string strcompanyid = objlogin.getsubdomain(Request.Url);
                //        ds = objlogin.ExecuteString("select * from tblcompany where bstatus=1 and compcode='" + strcompanyid + "'");
                //        if (ds.Tables[0].Rows.Count > 0)
                //        {
                //            this.Page.Title = ds.Tables[0].Rows[0]["companyname"].ToString();
                //            litcompanyname.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                //            litcompanyname2.Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                //            ((Literal)this.Master.FindControl("litcompanyname3")).Text = ds.Tables[0].Rows[0]["companyname"].ToString();
                //            //((HtmlImage)this.Master.FindControl("imglogo")).Src = "../webfile/" + ds.Tables[0].Rows[0]["logoURL"].ToString();
                //            ((HtmlImage)this.Master.FindControl("imglogo")).Src = "../images/HCLLP-Logo.png";
                //            app_hid_company.Value = ds.Tables[0].Rows[0]["nid"].ToString();

                //        }
                //        else
                //        {
                //            Response.Redirect("error.html");
                //        }

                //    }
                fillemp();
            }
        }
        public void fillemp()
        {           
            blGetMaster objda = new blGetMaster();
            ClsGeneral objgen = new ClsGeneral();
            DataSet ds = objda.GetEmpForAutoComplate(0, "ForAppointment", 1);
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
            //OnDate = (DateTime.ParseExact(OnDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

            //DataSet ds = objda.GetAppointmentAvailability(true, OnDate, OnDate, 0, Convert.ToInt64(HttpContext.Current.Session["OrgID"]), FKEmpID, "Available");

            //result = objgen.SerializeToJSON(ds);
            //string msg = "failure";
            //GeneralMethod objgen = new GeneralMethod();
            //DataSet ds = new DataSet();
            //ClsAppointment obj = new ClsAppointment();

            //try
            //{
            //    obj.action = "select";

            //    obj.nid = nid;


            //    ds = obj.APP_ManageAvailability();
            //    msg = objgen.serilizeinJson(ds.Tables[0]);
            //    return msg;
            //}
            //catch { return msg; }
            return "";


        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getEmpAvailability(int empid)
        {
            string msg = "failure";
            blAppointment objda = new blAppointment();
            ClsGeneral objgen = new ClsGeneral();

            

            //GeneralMethod objgen = new GeneralMethod();
            //DataSet ds = new DataSet();
            //ClsAppointment obj = new ClsAppointment();

            try
            {
                //    obj.aDate = GeneralMethod.getLocalDate();

                //    obj.empid = empid;


                //    ds = obj.APP_getAvailability();
                object onDate = objgen.GetLocalDate1();

                DataSet ds = objda.GetAppointmentAvailability(true, onDate, onDate, 0, 1, empid, "Available");
                msg = objgen.SerializeToJSON(ds);
                //msg = ds.Tables[0].Rows[0][0].ToString();
                return msg;
            }
            catch { return msg; }

            //return empid;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string saveEmpAvailability(string sloatid,string empid,string aDate, string frmTime, string ToTime, string vName, string designation, string company, string email, string contactno,string service)
        {
        //string msg = "failure";
        //GeneralMethod objgen = new GeneralMethod();
        //DataSet ds = new DataSet();
        //ClsAppointment obj = new ClsAppointment();

        //DataAccess objda = new DataAccess();
        //try
        //{
        //    DateTime timetotime = new DateTime();
        //    string totime;
        //    timetotime = Convert.ToDateTime(aDate + " " + frmTime);
        //    timetotime = timetotime.AddHours(1);

        //   totime=timetotime.ToString(@"hh:mm tt", new System.Globalization.CultureInfo("en-US")).ToLower();

        //    obj.aDate = aDate;
        //    obj.afrmTime = frmTime;

        //    obj.aToTime = string.Join("", totime.Split(default(string[]), StringSplitOptions.RemoveEmptyEntries));
        //    obj.vname = vName;
        //    obj.desig = designation;
        //    obj.companyid = company;
        //    obj.email = email;
        //    obj.contact = contactno;
        //    obj.service = service;
        //    obj.nid = "";
        //    obj.status = "Pending";
        //    obj.sloatid = sloatid;
        //    obj.empid = empid;
        //    obj.action = "insert";
        //    ds = obj.APP_ManageAppointment_new();

        //    if (ds.Tables[0].Rows.Count > 0)
        //    {
        //        try
        //        {
        //            string HTMLTemplatePath = HttpContext.Current.Server.MapPath("~/EmailTemplates/appointmentReqForAdmin.htm");
        //            string HTMLBODY = File.Exists(HTMLTemplatePath) ? File.ReadAllText(HTMLTemplatePath) : "";
        //            HTMLBODY = HTMLBODY.Replace(@"##logourl##", ds.Tables[0].Rows[0]["schedulerURL"].ToString() + "/webfile/" + ds.Tables[0].Rows[0]["logourl"].ToString());
        //            HTMLBODY = HTMLBODY.Replace("##company##", ds.Tables[0].Rows[0]["companyname"].ToString());
        //            HTMLBODY = HTMLBODY.Replace("##date##", ds.Tables[0].Rows[0]["adate1"].ToString() + " " + ds.Tables[0].Rows[0]["frmTime"].ToString().Replace("am", " AM").Replace("pm", " PM"));

        //            HTMLBODY = HTMLBODY.Replace("##Date##", ds.Tables[0].Rows[0]["adate1"].ToString());
        //            HTMLBODY = HTMLBODY.Replace(" ##purpose##", ds.Tables[0].Rows[0]["service"].ToString());
        //            HTMLBODY = HTMLBODY.Replace(" ##visitorname##", ds.Tables[0].Rows[0]["vName"].ToString());
        //            HTMLBODY = HTMLBODY.Replace("##empname##", ds.Tables[0].Rows[0]["empname"].ToString());
        //            HTMLBODY = HTMLBODY.Replace("##company##", ds.Tables[0].Rows[0]["company"].ToString());
        //            HTMLBODY = HTMLBODY.Replace("##email##", ds.Tables[0].Rows[0]["email"].ToString());
        //            HTMLBODY = HTMLBODY.Replace("##contact##", ds.Tables[0].Rows[0]["contactno"].ToString());
        //            HTMLBODY = HTMLBODY.Replace(@"##appurl##", ds.Tables[0].Rows[0]["schedulerURL"].ToString() + "/Appoint_ViewAppointments.aspx?appointmentid=" + ds.Tables[0].Rows[0]["nid"].ToString());

        //            string msg1 = objda.SendAppEmail(ds.Tables[0].Rows[0]["empemail"].ToString() + ",", "New Appointment Request for Date " + ds.Tables[0].Rows[0]["adate1"].ToString(), HTMLBODY, "garima.pathak@harshwal.com,", "", "", ds.Tables[0].Rows[0]["company"].ToString());
        //            if (msg1 == "Sent")
        //            {
        //            }
        //        }
        //        catch
        //        {

        //        }

        //    }
        //    msg = "1";
        //    return msg;
        //}
        //catch { return msg; }

        return "";

        }
    }
}
