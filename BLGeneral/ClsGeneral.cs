using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Net.Mail;
using System.Xml.Linq;

namespace BLGeneral
{
    public class ClsGeneral
    {
        public static string DateFormat = "dd/MM/yyyy";
        public string CountryName { get; set; }
        public string FormatXML(string StrXML)
        {
            try
            {
                XDocument doc = XDocument.Parse(StrXML);
                return doc.ToString();
            }
            catch (Exception)
            {
                // Handle and throw if fatal exception here; don't just ignore them
                return StrXML;
            }
        }

        public string SerializeToJSON(DataTable dt)
        {
            var settings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore,
                MissingMemberHandling = MissingMemberHandling.Ignore
            };
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt, Formatting.Indented, settings);
        }
        public string SerializeToJSON(DataSet ds)
        {
            var settings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore,
                MissingMemberHandling = MissingMemberHandling.Ignore
            };
            return @"{""data"":" + Newtonsoft.Json.JsonConvert.SerializeObject(ds, Formatting.Indented, settings) + "}";
        }
        public string SerializeObjectToJSON(object obj)        {

            var settings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore,
                MissingMemberHandling = MissingMemberHandling.Ignore
            };
            return Newtonsoft.Json.JsonConvert.SerializeObject(obj, Formatting.Indented, settings);
        }
        // C# Function to Convert Json string to C# Datatable
        public DataTable DeserializeTooDataTable(string jsonString)
        {
            DataTable dt = new DataTable();
            dt = (DataTable)Newtonsoft.Json.JsonConvert.DeserializeObject(jsonString, (typeof(DataTable)));
            return dt;
        }
        public string WeekDayNameByNumber(Int32 DayNum)
        {
            string DayName = "";
            switch(DayNum)
            {
                case 1:
                    DayName = DayOfWeek.Monday.ToString();
                    break;
                case 2:
                    DayName = DayOfWeek.Tuesday.ToString();
                    break;
                case 3:
                    DayName = DayOfWeek.Wednesday.ToString();
                    break;
                case 4:
                    DayName = DayOfWeek.Thursday.ToString();
                    break;
                case 5:
                    DayName = DayOfWeek.Friday.ToString();
                    break;
                case 6:
                    DayName = DayOfWeek.Saturday.ToString();
                    break;
                case 7:
                    DayName = DayOfWeek.Sunday.ToString();
                    break;



            }
            return DayName;

        }

        public void RemoveTranAttachment(string StrAttachRemove)
        {

            if (StrAttachRemove != "")
            {
                string[] str = StrAttachRemove.Split(',');
                string path = AppDomain.CurrentDomain.BaseDirectory + "\\webfiles\\transaction\\";
                if (str.Length > 0)
                {
                    for(int i = 0; i < str.Length; i++)
                    {
                        if (str[i] != "")
                        {
                            if (File.Exists(path+str[i]))
                            {
                                try
                                {
                                    File.Delete(path + str[i]);
                                }
                                catch
                                {

                                }
                                
                            }

                        }
                    }
                }

            }
        }


        public static string GetRequestMACAddr()
        {
            string macAddr = "";
            return macAddr;
        }
        public static string GetRequestIP()
        {
            string userip ="";
            return userip;
        }
        public static DateTime GetEasternTime()
        {
            var timeUtc = DateTime.UtcNow;
            TimeZoneInfo easternZone = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
            DateTime easternTime = TimeZoneInfo.ConvertTimeFromUtc(timeUtc, easternZone);
            return easternTime;
        }
        
        public static string GetLocalDate(string UserDateFormat)
        {
            return DateTime.Now.ToString(UserDateFormat);
        }

        public static DateTime GetLocalDate()
        {
            return DateTime.Now;
        }


        public void SetDefaultData(DataTable dt)
        {
            int col = dt.Columns.Count;
            foreach (DataRow dr in dt.Rows)
            {
                for (int i = 0; i < col; i++)
                {
                    if (dr[i] == DBNull.Value)
                    {
                        if (dt.Columns[i].DataType == typeof(string))
                        {
                            dr[i] = "";
                        }
                        else if (dt.Columns[i].DataType == typeof(Int64) || dt.Columns[i].DataType == typeof(Int32) || dt.Columns[i].DataType == typeof(Int16) || dt.Columns[i].DataType == typeof(decimal))
                        {
                            dr[i] = 0;
                        }

                    }
                }
            }
            dt.AcceptChanges();

        }
        public void SetDefaultData(DataSet ds)
        {

            foreach (DataTable dt in ds.Tables)
            {
                SetDefaultData(dt);
            }


        }
        public string SetAddress(string Addr1, string Addr2, string Country, string State, string City, string Tahsil, string Zip)
        {
            var strAddr = Addr1;
            if (Addr2 != "")
            {
                if (strAddr == "")
                {
                    strAddr = Addr2;
                }
                else
                {
                    strAddr = strAddr + "<br/>" + Addr2;
                }
            }
            if (Tahsil != "" && Tahsil!=City)
            {
                if (strAddr != "")
                {
                    strAddr = strAddr + "<br/>";
                }
                strAddr = strAddr + Tahsil;
            }
            if (City != "")
            {
                if (strAddr != "")
                {
                    strAddr = strAddr + ", ";
                }
                strAddr = strAddr + City;
            }
            if (State != "")
            {
                if (City != "")
                {
                    strAddr = strAddr + ", ";
                }
                else if (strAddr != "")
                {
                    strAddr = strAddr + "<br/>";
                }
                strAddr = strAddr + State;
            }
            if (Country != "" && CountryName!=Country)
            {
                if (State != "" || City != "")
                {
                    strAddr = strAddr + ", ";
                }
                else if (strAddr != "")
                {
                    strAddr = strAddr + "<br/>";
                }
                strAddr = strAddr + Country;
            }
            if (Zip != "")
            {
                if (State != "" || City != "" || Country != "")
                {
                    strAddr = strAddr + " - ";
                }
                else if (strAddr != "")
                {
                    strAddr = strAddr + "<br/>";
                }
                strAddr = strAddr + Zip;
            }
            return strAddr;
        }

        public string SetContactDetail(string Tel, string Fax, string Email, string Website)
        {
            var str = "";
            if (Tel != "") {
                str = "Tel: " + Tel+" ";
            }
            if (Fax != "")
            {
                str = "Fax: " + Fax + " ";
            }
            if (str != "") {
                str = str + "<br/>";
            }

            if (Email != "") {
                str = str + "Email: " + Email;
            }
            if (Website != "") {

                if (Email != "") {
                    str = str + ", ";
                }
                str = str + Website;
            }            
            return str;
        }

        public string SetMobileCode(string mobno)
        {
           
            mobno = mobno.Replace(" ", "");
            mobno = mobno.Replace("(", "");
            mobno = mobno.Replace(")", "");
            mobno = mobno.Replace("-", "");
            if (mobno.Length == 10)
            {
                mobno = mobno.Remove(1, 8).Insert(1, "XXXXXXX");
            }
            return mobno;
        }

        public string SetEmailCode(string Email)
        {
            string StrNewEmail = "";
            if(Email!="" && Email.IndexOf("@")>-1)
            {
                string[] str = Email.Split('@');
                
                for (int i=0;i< str[0].Length; i++)
                {
                    if (i == 0)
                    {
                        StrNewEmail = StrNewEmail+str[0][i];

                    }
                    else
                    {
                        StrNewEmail = StrNewEmail + "X";
                    }
                    
                   
                }
                StrNewEmail = StrNewEmail + "@" + str[1];
            }

            return StrNewEmail;
        }

        public string CreateOTP()
        {
            string[] saAllowedCharacters = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" };
            int iOTPLength = 6;
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
        public static string CurrencyToWords(double? numbers, Int64 FKCurrencyID,Boolean paisaconversion = false)
        {
            string StrRupees = "";
            string StrPaisa = "";
            if (FKCurrencyID == 1)
            {
                StrRupees = "Rupees";
                StrPaisa = "paisa";
            }
           else 
            {
                StrRupees = "Dollars";
                StrPaisa = "cents";
            }



            var pointindex = numbers.ToString().IndexOf(".");
            string[] strSpit = numbers.ToString().Split('.');
            var paisaamt = 0;
            if (pointindex > 0)
            {
              
                if (strSpit[1].Length == 1)
                {
                    paisaamt = Convert.ToInt32(strSpit[1]+"0");
                }
                else
                {
                    paisaamt = Convert.ToInt32(strSpit[1]);
                }
            }

             

            int number = Convert.ToInt32(numbers);

            if (number == 0) return "Zero";
            if (number == -2147483648) return "Minus Two Hundred and Fourteen Crore Seventy Four Lakh Eighty Three Thousand Six Hundred and Forty Eight";
            int[] num = new int[4];
            int first = 0;
            int u, h, t;
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            if (number < 0)
            {
                sb.Append("Minus ");
                number = -number;
            }
            string[] words0 = { "", "One ", "Two ", "Three ", "Four ", "Five ", "Six ", "Seven ", "Eight ", "Nine " };
            string[] words1 = { "Ten ", "Eleven ", "Twelve ", "Thirteen ", "Fourteen ", "Fifteen ", "Sixteen ", "Seventeen ", "Eighteen ", "Nineteen " };
            string[] words2 = { "Twenty ", "Thirty ", "Forty ", "Fifty ", "Sixty ", "Seventy ", "Eighty ", "Ninety " };
            string[] words3 = { "Thousand ", "Lakh ", "Crore " };
            num[0] = number % 1000; // units
            num[1] = number / 1000;
            num[2] = number / 100000;
            num[1] = num[1] - 100 * num[2]; // thousands
            num[3] = number / 10000000; // crores
            num[2] = num[2] - 100 * num[3]; // lakhs
            for (int i = 3; i > 0; i--)
            {
                if (num[i] != 0)
                {
                    first = i;
                    break;
                }
            }
            for (int i = first; i >= 0; i--)
            {
                if (num[i] == 0) continue;
                u = num[i] % 10; // ones
                t = num[i] / 10;
                h = num[i] / 100; // hundreds
                t = t - 10 * h; // tens
                if (h > 0) sb.Append(words0[h] + "Hundred ");
                if (u > 0 || t > 0)
                {
                    if (h > 0 || i == 0) sb.Append("and ");
                    if (t == 0)
                        sb.Append(words0[u]);
                    else if (t == 1)
                        sb.Append(words1[u]);
                    else
                        sb.Append(words2[t - 2] + words0[u]);
                }
                if (i != 0) sb.Append(words3[i - 1]);
            }

            if (paisaamt == 0 && paisaconversion == false)
            {
                sb.Append(StrRupees+" only");
            }            
            else if (paisaamt > 0)
            {
                var paisatext = CurrencyToWords(paisaamt,FKCurrencyID, true);
                sb.AppendFormat(StrRupees+" {0} "+StrPaisa+" only", paisatext);
            }
            return sb.ToString().TrimEnd();
        }
    }


    public class DateRange
    {
        public object fromdate;
        public object todate;
        public string datetext;
        public bool DateWise = true;



        public static DateRange getLastDates(string type, string fromdate, string todate, string UserDateFormat)
        {
            object date1 = new DateTime(), date2 = new DateTime();
            CultureInfo provider = CultureInfo.InvariantCulture;
             
            bool isDateWise = true;
            var today = Convert.ToDateTime(DateTime.Now);
            DayOfWeek weekStart = DayOfWeek.Monday; // or Sunday, or whenever
            DateTime startingDate = today;

            var month = new DateTime(today.Year, today.Month, 1);
            string str = "";
            type = type.ToLower();
            switch (type)
            {

                case "custom":
                    if (fromdate != "")
                        date1 = DateTime.ParseExact(fromdate, UserDateFormat, provider);
                    else
                        date1 = Convert.ToDateTime("01/01/1970");
                    if (todate != "")
                        date2 = DateTime.ParseExact(todate, UserDateFormat, provider);
                    else
                        date2 = today.AddYears(5);

                    str = "Report From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat);
                    break;
                case "quarterly":
                    int quarterNumber = (today.Month - 1) / 3 + 1;
                    date1 = new DateTime(today.Year, (quarterNumber - 1) * 3 + 1, 1);
                    date2 = Convert.ToDateTime(date1).AddMonths(3).AddDays(-1);
                    str = "Quarterly Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "monthly":

                    date1 = month.AddMonths(-1);
                    date2 = month.AddDays(-1);
                    str = "Monthly Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "weekly":
                    while (startingDate.DayOfWeek != weekStart)
                        startingDate = startingDate.AddDays(-1);

                    date1 = startingDate.AddDays(-7);
                    date2 = startingDate.AddDays(-1);
                    str = "Weekly Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "biweekly":

                    while (startingDate.DayOfWeek != weekStart)
                        startingDate = startingDate.AddDays(-1);

                    date1 = startingDate.AddDays(-14);
                    date2 = startingDate.AddDays(-1);
                    str = "Biweekly Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "current month":
                    date1 = new DateTime(today.Year, today.Month, 1);
                    date2 = Convert.ToDateTime(date1).AddMonths(1).AddDays(-1);
                    str = "Current Month Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "last month":
                    date1 = today.AddMonths(-1);
                    date1 = new DateTime(today.AddMonths(-1).Year, today.AddMonths(-1).Month, 1);
                    date2 = Convert.ToDateTime(date1).AddMonths(1).AddDays(-1);
                    str = "Last Month Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "next month":
                    date1 = new DateTime(today.AddMonths(1).Year, today.AddMonths(1).Month, 1);
                    date2 = Convert.ToDateTime(date1).AddMonths(1).AddDays(-1);
                    str = "Next Month Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "current week":

                    date1 = today.AddDays(-(int)today.DayOfWeek);
                    date2 = Convert.ToDateTime(date1).AddDays(7).AddSeconds(-1);
                    str = "Current Week Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "next week":

                    date1 = today.AddDays(7);
                    date1 = Convert.ToDateTime(date1).AddDays(-(int)Convert.ToDateTime(date1).DayOfWeek);
                    date2 = Convert.ToDateTime(date1).AddDays(7).AddSeconds(-1);
                    str = "Next Week Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;

                case "today":


                    date1 = today;
                    date2 = today;
                    str = "Report From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + "";
                    break;
                case "all":
                    date1 =null;
                    date2 = null;
                    str = "Date Filter: All";
                    isDateWise = false;
                    break;
                case "asof":
                    date1 = Convert.ToDateTime("01/01/1970");

                    if (todate != "")
                        date2 = DateTime.ParseExact(todate, UserDateFormat, provider);
                    else
                        date2 = today.AddDays(1);
                    str = "Report As of " + Convert.ToDateTime(date2).ToString(UserDateFormat);
                    break;
                case "asoflastmonth":
                    date1 = new DateTime(today.Year - 10, 1, 1).ToString();
                    date2 = new DateTime(today.Year, today.Month-1, 31).ToString();
                    str = "Report As of  Last Month (" + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "asoflastyear":
                    date1 = new DateTime(today.Year -10, 1, 1).ToString();
                    date2 = new DateTime(today.Year, 12, 31).ToString();
                    str = "Report As of  Last Year (" + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "thisweektodate":
                    date1 = today.AddDays(-(int)today.DayOfWeek);
                    date2 = today;
                    str = "This Week to Date Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "thismonthtodate":
                    date1 = new DateTime(today.Year, today.Month, 1);
                    date2 = today;
                    str = "This Month to Date Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;
                case "thisyeartodate":
                    date1 = new DateTime(today.Year, 1, 1).ToString();
                    date2 = today;
                    str = "This Year to Date Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;

                case "this calendar year":
                    date1 = new DateTime(today.Year, 1, 1).ToString();
                    date2 = new DateTime(today.Year, 12, 31).ToString();
                    str = "This Year Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;

                case "last calendar year":
                    date1 = new DateTime(today.Year-1, 1, 1).ToString();
                    date2 = new DateTime(today.Year-1, 12, 31).ToString();
                    str = "Last Year Report (From " + Convert.ToDateTime(date1).ToString(UserDateFormat) + " To " + Convert.ToDateTime(date2).ToString(UserDateFormat) + ")";
                    break;


            }

            var result = new DateRange
            {
                fromdate = date1,
                todate = date2,
                datetext = str,
                DateWise = isDateWise

            };
            return result;
        }

    }
}