using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using BL.Appointment;
using BL.Master;
using BL.Payroll;
using BL.Report;
using BL.Schedule;
using BLGeneral.Message;
using Org.BouncyCastle.Asn1.Crmf;

namespace QuickStartAdmin.Classes
{
    public class ClsSMSEmail
    {


        public EmailData CreateScheduleTemplate(DataSet dsTemp, int rownum, DataSet ds, Int64 FKCompanyID, Int64 FKSMSLocationID, Int64 FKUserID)
        {
            EmailData obReturn = new EmailData();
            obReturn.EnableEmail = false;

            if (dsTemp.Tables[0].Rows.Count > 0)
            {
                obReturn.EnableEmail = Convert.ToBoolean((dsTemp.Tables[0].Rows[rownum]["EnableEmail"]));
                obReturn.Message = Convert.ToString((dsTemp.Tables[0].Rows[rownum]["BodyContent"]));
                obReturn.To = Convert.ToString((dsTemp.Tables[0].Rows[rownum]["ReceiverEmail"]));
                obReturn.Subject = Convert.ToString((dsTemp.Tables[0].Rows[rownum]["EmailSubject"]));
                if (ds.Tables[0].Rows.Count > 0)
                {

                    obReturn.Message = obReturn.Message.Replace("[ClientName]", Convert.ToString((ds.Tables[0].Rows[0]["ClientName"])));
                    string strDate = Convert.ToString(ds.Tables[0].Rows[0]["FromDate"]);

                    if (Convert.ToString(ds.Tables[0].Rows[0]["FromDate"]) == Convert.ToString(ds.Tables[0].Rows[0]["ToDate"]))
                    {
                        obReturn.Message = obReturn.Message.Replace("[on]", "on");
                    }
                    else
                    {
                        strDate = "From " + strDate + " to " + Convert.ToString(ds.Tables[0].Rows[0]["ToDate"]);
                        obReturn.Message = obReturn.Message.Replace("[on]", "");
                    }

                    if (Convert.ToString(ds.Tables[0].Rows[0]["FromTime"]) != "")
                    {
                        strDate = strDate + " at " + Convert.ToString(ds.Tables[0].Rows[0]["FromTime"]);

                    }

                    obReturn.Message = obReturn.Message.Replace("[Date]", strDate);

                    obReturn.Message = obReturn.Message.Replace("[ProjectName]", Convert.ToString((ds.Tables[0].Rows[0]["ProjectName"])));
                    obReturn.Message = obReturn.Message.Replace("[WorkType]", Convert.ToString((ds.Tables[0].Rows[0]["WorkType"])));
                    obReturn.Message = obReturn.Message.Replace("[Status]", Convert.ToString((ds.Tables[0].Rows[0]["StatusTitle"])));

                    if (dsTemp.Tables[1].Rows.Count > 0)
                    {
                        if (Convert.ToString(dsTemp.Tables[1].Rows[0]["LogoURL"]) != "")
                        {
                            obReturn.Message = obReturn.Message.Replace("[LogoURL]", System.Web.Configuration.WebConfigurationManager.AppSettings["WebURL"].ToString() + "/Users/UserFiles/Logo/" + Convert.ToString((dsTemp.Tables[1].Rows[0]["LogoURL"])));
                        }
                        else
                        {
                            obReturn.Message = obReturn.Message.Replace("[LogoURL]", System.Web.Configuration.WebConfigurationManager.AppSettings["WebURL"].ToString() + "/img/logo.png");

                        }
                    }

                }


            }
            if (dsTemp.Tables[1].Rows.Count > 0)
            {
                obReturn.SenderEmail = Convert.ToString((dsTemp.Tables[1].Rows[0]["SenderEmail"]));
                obReturn.SenderPWD = Convert.ToString((dsTemp.Tables[1].Rows[0]["SenderPWD"]));
                obReturn.SMTPPort = Convert.ToInt32((dsTemp.Tables[1].Rows[0]["SMTPPort"]));
                obReturn.SMTPServer = Convert.ToString((dsTemp.Tables[1].Rows[0]["SMTPServer"]));
                obReturn.EnableSSL = Convert.ToBoolean((dsTemp.Tables[1].Rows[0]["EnableSSL"]));
            }

            return obReturn;

        }

        public EmailData CreateAppointmentTemplate(DataSet dsTemp, int rownum, DataSet ds, Int64 FKCompanyID, Int64 FKSMSLocationID, Int64 FKUserID)
        {
            EmailData obReturn = new EmailData();
            obReturn.EnableEmail = false;

            if (dsTemp.Tables[0].Rows.Count > 0)
            {
                obReturn.EnableEmail = Convert.ToBoolean((dsTemp.Tables[0].Rows[rownum]["EnableEmail"]));
                obReturn.Message = Convert.ToString((dsTemp.Tables[0].Rows[rownum]["BodyContent"]));
                obReturn.To = Convert.ToString((dsTemp.Tables[0].Rows[rownum]["ReceiverEmail"]));
                obReturn.Subject = Convert.ToString((dsTemp.Tables[0].Rows[rownum]["EmailSubject"]));

                if (ds.Tables[0].Rows.Count > 0)
                {
                    obReturn.CC = Convert.ToString((ds.Tables[0].Rows[rownum]["EmpEmailID"]));
                    obReturn.Message = obReturn.Message.Replace("[EmpName]", Convert.ToString((ds.Tables[0].Rows[0]["EmpName"])));
                    obReturn.Message = obReturn.Message.Replace("[Visitor]", Convert.ToString((ds.Tables[0].Rows[0]["CutomerName"])));

                    string strDate = Convert.ToString(ds.Tables[0].Rows[0]["OnDate"]);
                    strDate = strDate + " From " + Convert.ToString(ds.Tables[0].Rows[0]["FromTime"]) + " to " + Convert.ToString(ds.Tables[0].Rows[0]["ToTime"]);


                    obReturn.Message = obReturn.Message.Replace("[Date]", strDate);

                    obReturn.Message = obReturn.Message.Replace("[Email]", Convert.ToString((ds.Tables[0].Rows[0]["EmailID"])));
                    obReturn.Message = obReturn.Message.Replace("[Cell]", Convert.ToString((ds.Tables[0].Rows[0]["Mobile"])));
                    obReturn.Message = obReturn.Message.Replace("[Status]", Convert.ToString((ds.Tables[0].Rows[0]["ApproveStatus"])));
                    obReturn.Message = obReturn.Message.Replace("[Remarks]", Convert.ToString((ds.Tables[0].Rows[0]["Remarks"])));
                    if (dsTemp.Tables[1].Rows.Count > 0)
                    {
                        if (Convert.ToString(dsTemp.Tables[1].Rows[0]["LogoURL"]) != "")
                        {
                            obReturn.Message = obReturn.Message.Replace("[LogoURL]", System.Web.Configuration.WebConfigurationManager.AppSettings["WebURL"].ToString() + "/Users/UserFiles/Logo/" + Convert.ToString((dsTemp.Tables[1].Rows[0]["LogoURL"])));
                        }
                        else
                        {
                            obReturn.Message = obReturn.Message.Replace("[LogoURL]", System.Web.Configuration.WebConfigurationManager.AppSettings["WebURL"].ToString() + "/img/logo.png");

                        }
                    }

                }


            }
            if (dsTemp.Tables[1].Rows.Count > 0)
            {
                obReturn.SenderEmail = Convert.ToString((dsTemp.Tables[1].Rows[0]["SenderEmail"]));
                obReturn.SenderPWD = Convert.ToString((dsTemp.Tables[1].Rows[0]["SenderPWD"]));
                obReturn.SMTPPort = Convert.ToInt32((dsTemp.Tables[1].Rows[0]["SMTPPort"]));
                obReturn.SMTPServer = Convert.ToString((dsTemp.Tables[1].Rows[0]["SMTPServer"]));
                obReturn.EnableSSL = Convert.ToBoolean((dsTemp.Tables[1].Rows[0]["EnableSSL"]));
            }

            return obReturn;

        }

        public EmailData CreateLeaveTemplate(DataSet dsTemp, int rownum, DataSet ds, Int64 FKCompanyID, Int64 FKSMSLocationID, Int64 FKUserID)
        {
            EmailData obReturn = new EmailData();
            obReturn.EnableEmail = false;

            if (dsTemp.Tables[0].Rows.Count > 0)
            {
                obReturn.EnableEmail = Convert.ToBoolean((dsTemp.Tables[0].Rows[rownum]["EnableEmail"]));
                obReturn.Message = Convert.ToString((dsTemp.Tables[0].Rows[rownum]["BodyContent"]));
                obReturn.To = Convert.ToString((dsTemp.Tables[0].Rows[rownum]["ReceiverEmail"]));
                obReturn.Subject = "Leave Request of " + Convert.ToString(ds.Tables[0].Rows[0]["EmpName"]);
                if (ds.Tables[0].Rows.Count > 0)
                {

                    obReturn.Message = obReturn.Message.Replace("[EmpName]", Convert.ToString((ds.Tables[0].Rows[0]["EmpName"])));
                    obReturn.Message = obReturn.Message.Replace("[LeaveName]", Convert.ToString((ds.Tables[0].Rows[0]["LeaveName"])));

                    string strDate = Convert.ToString(ds.Tables[0].Rows[0]["FromDate"]);

                    if (Convert.ToString(ds.Tables[0].Rows[0]["FromDate"]) == Convert.ToString(ds.Tables[0].Rows[0]["ToDate"]))
                    {
                        obReturn.Message = obReturn.Message.Replace("[DayCount]", Convert.ToString(ds.Tables[0].Rows[0]["LeaveCount"]) + " day");

                        strDate = "on " + Convert.ToString(ds.Tables[0].Rows[0]["FromDate"]);
                        obReturn.Message = obReturn.Message.Replace("[FromToDate]", strDate);
                        obReturn.Message = obReturn.Message.Replace("[Date]", Convert.ToString(ds.Tables[0].Rows[0]["FromDate"]));
                    }
                    else
                    {
                        obReturn.Message = obReturn.Message.Replace("[DayCount]", Convert.ToString(ds.Tables[0].Rows[0]["LeaveCount"]) + " days");

                        strDate = "From " + strDate + " to " + Convert.ToString(ds.Tables[0].Rows[0]["ToDate"]);
                        obReturn.Message = obReturn.Message.Replace("[FromToDate]", strDate);
                        obReturn.Message = obReturn.Message.Replace("[Date]", strDate);
                    }




                    obReturn.Message = obReturn.Message.Replace("[NoOfDays]", Convert.ToString((ds.Tables[0].Rows[0]["LeaveCount"])));
                    obReturn.Message = obReturn.Message.Replace("[LeaveName]", Convert.ToString((ds.Tables[0].Rows[0]["LeaveName"])));
                    obReturn.Message = obReturn.Message.Replace("[Remarks]", Convert.ToString((ds.Tables[0].Rows[0]["Remarks"])));
                    obReturn.Message = obReturn.Message.Replace("[ApproveStatus]", Convert.ToString((ds.Tables[0].Rows[0]["ApproveStatus"])));
                    obReturn.Message = obReturn.Message.Replace("[ApproveByName]", Convert.ToString((ds.Tables[0].Rows[0]["ApproveByName"])));
                    obReturn.Message = obReturn.Message.Replace("[RejectReason]", Convert.ToString((ds.Tables[0].Rows[0]["RejectReason"])));


                    if (dsTemp.Tables[1].Rows.Count > 0)
                    {
                        if (Convert.ToString(dsTemp.Tables[1].Rows[0]["LogoURL"]) != "")
                        {
                            obReturn.Message = obReturn.Message.Replace("[LogoURL]", System.Web.Configuration.WebConfigurationManager.AppSettings["WebURL"].ToString() + "/Users/UserFiles/Logo/" + Convert.ToString((dsTemp.Tables[1].Rows[0]["LogoURL"])));
                        }
                        else
                        {
                            obReturn.Message = obReturn.Message.Replace("[LogoURL]", System.Web.Configuration.WebConfigurationManager.AppSettings["WebURL"].ToString() + "/img/logo.png");

                        }
                    }

                }


            }
            if (dsTemp.Tables[1].Rows.Count > 0)
            {
                obReturn.SenderEmail = Convert.ToString((dsTemp.Tables[1].Rows[0]["SenderEmail"]));
                obReturn.SenderPWD = Convert.ToString((dsTemp.Tables[1].Rows[0]["SenderPWD"]));
                obReturn.SMTPPort = Convert.ToInt32((dsTemp.Tables[1].Rows[0]["SMTPPort"]));
                obReturn.SMTPServer = Convert.ToString((dsTemp.Tables[1].Rows[0]["SMTPServer"]));
                obReturn.EnableSSL = Convert.ToBoolean((dsTemp.Tables[1].Rows[0]["EnableSSL"]));
            }

            return obReturn;

        }

        public string SendScheduleEmail(Int64 PKID, Int64 FKCompanyID, string CType, Int64 FKSMSLocationID, Int64 FKUserID, Int64 FKPageID)
        {
            string msg = string.Empty;
            blCompany objdaCompany = new blCompany();
            objdaCompany.PKCompanyID = FKCompanyID;
            DataSet dsTemp = objdaCompany.GetEmailTemplate(FKSMSLocationID);
            blSchedule objda = new blSchedule();
            DataSet ds = new DataSet();
            ds = objda.GetClientSchedule(0, 0, "", "", false, null, null, PKID, FKCompanyID, "", "", "", 0, 0);

            if (CType == "manual")
            {
                DataRow dr = null;
                if (dsTemp.Tables[0].Rows.Count == 0)
                {
                    dr = dsTemp.Tables[0].NewRow();
                    dsTemp.Tables[0].Rows.Add();
                }
                else
                {
                    dr = dsTemp.Tables[0].Rows[0];
                }
                dr["EmailSubject"] = "You have scheduled for " + Convert.ToString(ds.Tables[0].Rows[0]["ClientName"]);
                dr["EnableEmail"] = true;
                dr["FKEmailMsgLocID"] = 2;
                string strReceiver = "";

                foreach (DataRow dremp in ds.Tables[1].Rows)
                {
                    if (Convert.ToString(dremp["EmailID"]) != "")
                    {
                        strReceiver = strReceiver + Convert.ToString(dremp["EmailID"]) + ",";
                    }
                }
                dr["ReceiverEmail"] = strReceiver;

                string strHTML = File.ReadAllText(System.Web.Hosting.HostingEnvironment.MapPath("~/Users/EmailTemplate/ScheduleEmail.html"));
                dr["BodyContent"] = strHTML;

                dsTemp.AcceptChanges();

            }



            if (dsTemp.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows.Count > 0 && Convert.ToBoolean((dsTemp.Tables[0].Rows[0]["EnableEmail"])))
            {

                EmailData obReturn = CreateScheduleTemplate(dsTemp, 0, ds, FKCompanyID, FKSMSLocationID, FKUserID);
                if (obReturn.EnableEmail && obReturn.SenderEmail != "" && obReturn.To != "")
                {
                    msg = ClsSendSMSEmail.SendEmailSync(obReturn);
                }

            }

            return msg;

        }

        public string SendLeaveEmail(Int64 PKID, Int64 FKCompanyID, string CType, Int64 FKSMSLocationID, Int64 FKUserID, Int64 FKPageID)
        {
            string msg = string.Empty;
            try
            {
                blCompany objdaCompany = new blCompany();
                objdaCompany.PKCompanyID = FKCompanyID;
                DataSet dsTemp = objdaCompany.GetEmailTemplate(FKSMSLocationID);
                blPayroll objda = new blPayroll();
                DataSet ds = new DataSet();
                ds = objda.GetLeaveRequest(0, 0, "", "", false, null, null, PKID, FKCompanyID, 0, 0, "", "");

                if (dsTemp.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows.Count > 0 && Convert.ToBoolean((dsTemp.Tables[0].Rows[0]["EnableEmail"])))
                {
                    string strHTML = "";


                    if (CType == "new")
                    {

                        strHTML = File.ReadAllText(System.Web.Hosting.HostingEnvironment.MapPath("~/Users/EmailTemplate/LeaveRequest.html"));

                    }
                    else if (CType == "issue")
                    {

                        strHTML = File.ReadAllText(System.Web.Hosting.HostingEnvironment.MapPath("~/Users/EmailTemplate/IssueLeave.html"));

                    }
                    else if (CType == "approve")
                    {

                        strHTML = File.ReadAllText(System.Web.Hosting.HostingEnvironment.MapPath("~/Users/EmailTemplate/ApproveLeave.html"));

                    }

                    dsTemp.Tables[0].Rows[0]["BodyContent"] = strHTML;
                    dsTemp.AcceptChanges();
                    EmailData obReturn = CreateLeaveTemplate(dsTemp, 0, ds, FKCompanyID, FKSMSLocationID, FKUserID);
                    if (obReturn.EnableEmail && obReturn.SenderEmail != "" && obReturn.To != "")
                    {
                        if (CType == "issue")
                        {
                            obReturn.CC = obReturn.To;
                            obReturn.To = Convert.ToString(ds.Tables[0].Rows[0]["EmailID"]);
                            obReturn.Subject = "Leave Issued";

                        }
                        else if (CType == "approve")
                        {
                            obReturn.CC = obReturn.To;
                            obReturn.To = Convert.ToString(ds.Tables[0].Rows[0]["EmailID"]);
                            if (Convert.ToString(ds.Tables[0].Rows[0]["ApproveStatus"]) == "Approved")
                                obReturn.Subject = "Leave Request Approved";
                            else
                                obReturn.Subject = "Leave Request Rejected";

                        }

                        msg = ClsSendSMSEmail.SendEmailSync(obReturn);
                    }

                }
            }
            catch (Exception ex)
            {
                msg = ex.Message;
            }
            return msg;


        }
        public string SendAppointmentEmail(Int64 PKID, Int64 FKCompanyID, string CType, Int64 FKSMSLocationID, Int64 FKUserID, Int64 FKPageID)
        {
            string msg = string.Empty;
            blCompany objdaCompany = new blCompany();
            objdaCompany.PKCompanyID = FKCompanyID;
            DataSet dsTemp = objdaCompany.GetEmailTemplate(FKSMSLocationID);
            blAppointment objda = new blAppointment();
            DataSet ds = new DataSet();
            ds = objda.GetAppointment(0, 0, "", "", false, null, null, PKID, FKCompanyID, "", 0, "");

            if (CType == "new")
            {
                DataRow dr = null;
                if (dsTemp.Tables[0].Rows.Count == 0)
                {
                    dr = dsTemp.Tables[0].NewRow();
                    dsTemp.Tables[0].Rows.Add();
                }
                else
                {
                    dr = dsTemp.Tables[0].Rows[0];
                }
                dsTemp.AcceptChanges();
                dsTemp.Tables[0].Rows[0]["EmailSubject"] = "Your appointment with " + Convert.ToString(ds.Tables[0].Rows[0]["EmpName"]);
                dsTemp.Tables[0].Rows[0]["EnableEmail"] = true;
                dsTemp.Tables[0].Rows[0]["FKEmailMsgLocID"] = 4;
                string strReceiver = "";

                if (Convert.ToString(ds.Tables[0].Rows[0]["EmailID"]) != "")
                {
                    strReceiver = strReceiver + Convert.ToString(ds.Tables[0].Rows[0]["EmailID"]) + ",";
                }
                dsTemp.Tables[0].Rows[0]["ReceiverEmail"] = strReceiver;

                string strHTML = File.ReadAllText(System.Web.Hosting.HostingEnvironment.MapPath("~/Users/EmailTemplate/AppointmentEmail.html"));
                dsTemp.Tables[0].Rows[0]["BodyContent"] = strHTML;
                dsTemp.Tables[0].AcceptChanges();
                dsTemp.AcceptChanges();

            }



            if (dsTemp.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows.Count > 0 && Convert.ToBoolean((dsTemp.Tables[0].Rows[0]["EnableEmail"])))
            {

                EmailData obReturn = CreateAppointmentTemplate(dsTemp, 0, ds, FKCompanyID, FKSMSLocationID, FKUserID);
                if (obReturn.EnableEmail && obReturn.SenderEmail != "" && obReturn.To != "")
                {
                    msg = ClsSendSMSEmail.SendEmailSync(obReturn);
                }

            }

            return msg;

        }

        public static string GenerateRandomOTP(int iOTPLength)

        {
            string[] saAllowedCharacters = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" };
            string sOTP = String.Empty;

            string sTempChars = String.Empty;

            Random rand = new Random();

            for (int i = 0; i < iOTPLength; i++)

            {

                int p = rand.Next(0, saAllowedCharacters.Length);

                sTempChars = saAllowedCharacters[rand.Next(0, saAllowedCharacters.Length)];

                sOTP += sTempChars;

            }

            return sOTP;

        }
    }
}