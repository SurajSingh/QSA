using System;
using System.Net.Mail;
using System.Threading;
using System.Threading.Tasks;

namespace BLGeneral.Message
{
    public class SMSData
    {
        public string API { get; set; }
        public string MobNo { get; set; }
        public string Message { get; set; }
        public bool EnableSMS { get; set; }

        public SMSData()
        {
            API = "";
            MobNo = "";
            Message = "";
            EnableSMS = true;

        }
    }
    public class EmailData
    {
        public string SenderEmail { get; set; }
        public string SenderPWD { get; set; }
        public string SMTPServer { get; set; }
        public Int32 SMTPPort { get; set; }
        public bool EnableSSL { get; set; }
        public string To { get; set; }
        public string CC { get; set; }
        public string BCC { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public string Attachments { get; set; }
        public bool EnableEmail { get; set; }
        public EmailData()
        {
            SenderEmail = "";
            SenderPWD = "";
            SMTPServer = "";
            SMTPPort = 25;
            EnableSSL = false;
            To = "";
            CC = "";
            BCC = "";
            Subject = "";
            Message = "";
            Attachments = "";
            EnableEmail = true;
        }
    }
    public class ClsSendSMSEmail
    {


        public static void SendSMSAsync(SMSData ObjectSMSData)
        {
            Task.Factory.StartNew(() => SendSMS(ObjectSMSData));
        }
        public static string SendEmailAsync(EmailData ObjectEmailDat)
        {
           return SendEmail(ObjectEmailDat);
        }

        public static string SendEmailSync(EmailData ObjectEmailDat)
        {
            return SendEmail(ObjectEmailDat);
        }

        private static string SendSMS(SMSData ObjectSMSData)
        {
            string StrResult = "0";
            try
            {
                string API = ObjectSMSData.API;
                string Message = ObjectSMSData.Message;
                string MobNo = ObjectSMSData.MobNo;

                Message = Message.Replace("&", "&amp;");
                API = API.Replace("[MobileNo]", MobNo);
                API = API.Replace("[Message]", Message);
                System.Net.WebClient client = new System.Net.WebClient();
                System.IO.Stream data = client.OpenRead(API);
                System.IO.StreamReader reader = new System.IO.StreamReader(data);
                string s = reader.ReadToEnd();
                data.Close();
                reader.Close();
                StrResult = "1";

            }
            catch (Exception ex)
            {
                StrResult = ex.ToString();
            }
            return StrResult;
        }
        private static string SendEmail(EmailData ObjectEmailData)
        {
            string StrResult = "0";
            string SenderEmail = ObjectEmailData.SenderEmail;
            string SenderPWD = ObjectEmailData.SenderPWD;
            string SMTPServer = ObjectEmailData.SMTPServer;
            Int32 SMTPPort = ObjectEmailData.SMTPPort;
            bool EnableSSL = ObjectEmailData.EnableSSL;
            string To = ObjectEmailData.To;
            string CC = ObjectEmailData.CC;
            string BCC = ObjectEmailData.BCC;
            string Subject = ObjectEmailData.Subject;
            string Message = ObjectEmailData.Message;
            string Attachments = ObjectEmailData.Attachments;
            try
            {
                System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
                mail.From = new MailAddress(SenderEmail);
                mail.Subject = Subject;
                mail.Body = Message;
                mail.IsBodyHtml = true;
                SmtpClient smtp = new SmtpClient();
                smtp.Host = SMTPServer;
                smtp.EnableSsl = EnableSSL;
                if (SMTPServer.IndexOf("sendgrid") > -1)
                {
                    smtp.Credentials = new System.Net.NetworkCredential("apikey", SenderPWD);
                }
                else
                {
                    smtp.Credentials = new System.Net.NetworkCredential(SenderEmail, SenderPWD);
                    //smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                    //smtp.UseDefaultCredentials = true;
                }

                smtp.Port = SMTPPort;

                if (To.IndexOf(",") > -1)
                {
                    string[] ArrTo = To.Split(',');
                    for (int i = 0; i < ArrTo.Length; i++)
                    {
                        if (ArrTo[i] != "")
                            mail.To.Add(ArrTo[i]);
                    }
                }
                else
                {
                    mail.To.Add(To);
                }


                if (CC != "")
                {
                    if (CC.IndexOf(",") > -1)
                    {
                        string[] strcc = CC.Split(',');

                        for (int i = 0; i < strcc.Length - 1; i++)
                        {
                            if (strcc[i] != "")
                                mail.CC.Add(new MailAddress(strcc[i]));

                        }
                    }
                    else
                    {
                        mail.CC.Add(new MailAddress(CC));
                    }

                }
                if (BCC != "")
                {
                    if (CC.IndexOf(",") > -1)
                    {
                        string[] StrBCC = BCC.Split(',');

                        for (int i = 0; i < StrBCC.Length - 1; i++)
                        {
                            if (StrBCC[i] != "")
                                mail.Bcc.Add(new MailAddress(StrBCC[i]));
                        }
                    }
                    else
                    {
                        mail.Bcc.Add(new MailAddress(BCC));
                    }

                }
                if (Attachments != "")
                {
                    if (Attachments.IndexOf(",") > -1)
                    {
                        string[] StrAttachments = Attachments.Split(',');

                        for (int i = 0; i < StrAttachments.Length - 1; i++)
                        {
                            if (StrAttachments[i] != "")
                            {
                                mail.Attachments.Add(new System.Net.Mail.Attachment(AppDomain.CurrentDomain.BaseDirectory + "\\TempFile\\" + Attachments[i]));
                            }
                        }
                    }
                    else
                    {
                        mail.Attachments.Add(new System.Net.Mail.Attachment(AppDomain.CurrentDomain.BaseDirectory + "\\TempFile\\" + Attachments));
                    }
                }

                smtp.Send(mail); StrResult = "1";
            }
            catch (Exception ex)
            {
                StrResult = $"<b>Mail sending failed:</b>{ex.Message.ToString()}";
            }
            return StrResult;
        }
    }
}
