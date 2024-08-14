using BL.Master;
using BLGeneral;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;

namespace QuickStartAdmin.Classes
{
    public class ClsTransactionPrintLayout
    {
        public ClsGeneral objgen = new ClsGeneral();
        public Int64 FKTranTypeID { get; set; }
        public string RecType { get; set; }
        public string TranCurrencySymbol { get; set; }
        public Int64 FKTranCurrencyID { get; set; }
        public Int64 FKCompanyID { get; set; }
       
        public Int64 FKUserID { get; set; }
        public Int64 FKPageID { get; set; }
        public DataSet dsConfig = new DataSet();
        public string CountryName { get; set; }
        public ClsTransactionPrintLayout()
        {
            FKTranTypeID = 0;
            TranCurrencySymbol = "";
            FKTranCurrencyID = 1;
            FKCompanyID = 0;
           
            FKUserID = 0;
            FKPageID = 0;
            RecType = "";
        }
        public ClsTransactionPrintLayout(Int64 FKPageID, Int64 FKTranTypeID, string TranCurrencySymbol, Int64 FKTranCurrencyID, Int64 FKCompanyID, Int64 FKUserID)
        {
            this.FKTranTypeID = FKTranTypeID;
            this.TranCurrencySymbol = TranCurrencySymbol;
            this.FKTranCurrencyID = FKTranCurrencyID;
            this.FKCompanyID = FKCompanyID;
            
            this.FKUserID = FKUserID;
            this.FKPageID = FKPageID;
        }


        public string SetHeader(string str, Int64 FKNewBranchID = 0)
        {
            int tablenum = 0;
            blCompany objda = new blCompany();
            objda.PKCompanyID = Convert.ToInt64(FKCompanyID);
           
            DataSet ds = objda.GetCompanyForReport();

            CountryName = Convert.ToString(ds.Tables[tablenum].Rows[0]["CompanyName"]);

            if (Convert.ToString(ds.Tables[tablenum].Rows[0]["LogoURL"]) != "")
            {
                str = str.Replace("[CompanyLogo]", "<img src='" + System.Web.Configuration.WebConfigurationManager.AppSettings["WebURL"].ToString() + "/Users/UserFiles/Logo/" + Convert.ToString(ds.Tables[tablenum].Rows[0]["LogoURL"]) + "' style='width:120px;' />");
                str = str.Replace("[CompanyLogoURL]", System.Web.Configuration.WebConfigurationManager.AppSettings["WebURL"].ToString() + "/Users/UserFiles/Logo/" + Convert.ToString(ds.Tables[tablenum].Rows[0]["LogoURL"]));
            }
            else
            {
                str = str.Replace("[CompanyLogo]", "");
                str = str.Replace("[CompanyLogoURL]", "");
            }

           
            str = str.Replace("[CompanyName]", Convert.ToString(ds.Tables[tablenum].Rows[0]["CompanyName"]));
            if (Convert.ToString(ds.Tables[tablenum].Rows[0]["GSTNo"]) != "")
            {
                str = str.Replace("[GSTNo]", "GSTIN: " + Convert.ToString(ds.Tables[tablenum].Rows[0]["GSTNo"]));

            }
            else
            {
                str = str.Replace("[GSTNo]", "");

            }
            str = str.Replace("[GSTIN]", Convert.ToString(ds.Tables[tablenum].Rows[0]["GSTNo"]));
            string strAddress = "";

            strAddress = objgen.SetAddress(Convert.ToString(ds.Tables[tablenum].Rows[0]["Address1"]), Convert.ToString(ds.Tables[tablenum].Rows[0]["Address2"]), Convert.ToString(ds.Tables[tablenum].Rows[0]["CountryName"]), Convert.ToString(ds.Tables[tablenum].Rows[0]["StateName"]), Convert.ToString(ds.Tables[tablenum].Rows[0]["CityName"]), Convert.ToString(ds.Tables[tablenum].Rows[0]["TahsilName"]), Convert.ToString(ds.Tables[tablenum].Rows[0]["ZIP"]));
            str = str.Replace("[Address]", strAddress);

            str = str.Replace("[Address1]", Convert.ToString(ds.Tables[tablenum].Rows[0]["Address1"]));
            str = str.Replace("[Address2]", Convert.ToString(ds.Tables[tablenum].Rows[0]["Address2"]));
            str = str.Replace("[CityName]", Convert.ToString(ds.Tables[tablenum].Rows[0]["CityName"]));
            str = str.Replace("[StateName]", Convert.ToString(ds.Tables[tablenum].Rows[0]["StateName"]));
            str = str.Replace("[ZIP]", Convert.ToString(ds.Tables[tablenum].Rows[0]["ZIP"]));

            str = str.Replace("[Mobile]", Convert.ToString(ds.Tables[tablenum].Rows[0]["Mobile"]));
            str = str.Replace("[Phone]", Convert.ToString(ds.Tables[tablenum].Rows[0]["Phone"]));
            str = str.Replace("[Email]", Convert.ToString(ds.Tables[tablenum].Rows[0]["Email"]));
            str = str.Replace("[Website]", Convert.ToString(ds.Tables[tablenum].Rows[0]["Website"]));

            str = str.Replace("[CompanyCountry]", Convert.ToString(ds.Tables[tablenum].Rows[0]["CountryName"]));

           
            return str;
        }
        
      
        public string FillPayment(DataSet ds)
        {
            string str = "";

            if (ds.Tables[0].Rows.Count > 0)
            {
                string HTMLTemplatePath = "";
                if (RecType == "P") {
                    HTMLTemplatePath=System.Web.Hosting.HostingEnvironment.MapPath("~/Users/UserJs/PrintTemplate/HTML/PaymentVoucher.html");
                }
                else
                {
                    HTMLTemplatePath=System.Web.Hosting.HostingEnvironment.MapPath("~/Users/UserJs/PrintTemplate/HTML/ReceiptVoucher.html");
                }
                str = File.ReadAllText(HTMLTemplatePath);

                str = SetHeader(str);
                if (RecType=="P")
                {
                    str = str.Replace("[Title]", "PAYMENT SLIP");
                    str = str.Replace("[InvoiceNoTitle]", "Payment");
                }
                else
                {
                    str = str.Replace("[Title]", "RECEIPT SLIP");
                    str = str.Replace("[InvoiceNoTitle]", "Receipt No.");
                }

                str = str.Replace("[InvoiceNo]", Convert.ToString(ds.Tables[0].Rows[0]["EntryID"]));

                str = str.Replace("[ClientCompanyName]", Convert.ToString(ds.Tables[0].Rows[0]["AgentName"]));
                // str = str.Replace("[ClientID]", Convert.ToString(ds.Tables[0].Rows[0]["PartyID"]));

                str = str.Replace("[InvoiceDate]", Convert.ToString(ds.Tables[0].Rows[0]["TranDate"]));

                // str = str.Replace("[RefNo]", Convert.ToString(ds.Tables[0].Rows[0]["RefNo"]));
                // str = str.Replace("[RefDate]", Convert.ToString(ds.Tables[0].Rows[0]["RefDate"]));

                str = str.Replace("[Amount]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["Amount"]).ToString("0.00"));
                string AmtWord = ClsGeneral.CurrencyToWords(Convert.ToDouble(ds.Tables[0].Rows[0]["Amount"]), FKTranCurrencyID, false);
                str = str.Replace("[AmountWord]", AmtWord);


                // str = str.Replace("[NetAmt]", Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("0.00"));
                str = str.Replace("[PayMode]", Convert.ToString(ds.Tables[0].Rows[0]["PaymentMode"]));
               
                str = str.Replace("[InvoiceRemark]", Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]));

                string strAdj = "";
                if (RecType == "R")
                {
                    var i = 1;
                    foreach (DataRow dr in ds.Tables[1].Rows) {
                        strAdj += "<tr>";
                        strAdj += "<td>"+i.ToString()+"</td>";
                        strAdj += "<td>" +Convert.ToString(dr["EntryID"]) + "</td>";
                        strAdj += "<td>" + Convert.ToString(dr["BookingDate"]) + "</td>";
                        strAdj += "<td>" + Convert.ToString(dr["PolicyNo"]) + "</td>";
                        strAdj += "<td>" + Convert.ToString(dr["IssueDate"]) + "</td>";
                        strAdj += "<td style='text-align:right;'>" + Convert.ToDecimal(dr["Amount"]).ToString("0.00") + "</td>";
                        strAdj += "</tr>";
                    }
                   
                }
                str = str.Replace("[Adjustment]", strAdj);
            }
            return str;
        }
        public string FillPolicy (DataSet ds)
        {
            string str = "";

            if (ds.Tables[0].Rows.Count > 0)
            {
                string HTMLTemplatePath = "";
                HTMLTemplatePath = System.Web.Hosting.HostingEnvironment.MapPath("~/Users/UserJs/PrintTemplate/HTML/Policy.html");
                str = File.ReadAllText(HTMLTemplatePath);

                str = SetHeader(str);
               
                str = str.Replace("[Agent]", Convert.ToString(ds.Tables[0].Rows[0]["AgentName"]));
                str = str.Replace("[SubAgent]", Convert.ToString(ds.Tables[0].Rows[0]["SubAgentName"]));
                str = str.Replace("[CustomerName]", Convert.ToString(ds.Tables[1].Rows[0]["CustomerName"]));
                str = str.Replace("[CustomerMobile]", Convert.ToString(ds.Tables[1].Rows[0]["MobNo"]));
                str = str.Replace("[CustomerEmail]", Convert.ToString(ds.Tables[1].Rows[0]["EmailID"]));
                str = str.Replace("[OfficePhone]", Convert.ToString(ds.Tables[1].Rows[0]["Phone1"]));
                str = str.Replace("[HomePhone]", Convert.ToString(ds.Tables[1].Rows[0]["Phone2"]));
                str = str.Replace("[CustomerAddress]",objgen.SetAddress(Convert.ToString(ds.Tables[1].Rows[0]["Address1"]), Convert.ToString(ds.Tables[1].Rows[0]["Address2"]),"", Convert.ToString(ds.Tables[1].Rows[0]["StateName"]), Convert.ToString(ds.Tables[1].Rows[0]["CityName"]), Convert.ToString(ds.Tables[1].Rows[0]["TahsilName"]), Convert.ToString(ds.Tables[1].Rows[0]["ZIP"])));
                str = str.Replace("[PolicyNo]", Convert.ToString(ds.Tables[0].Rows[0]["PolicyNo"]));
                str = str.Replace("[IssueDate]", Convert.ToString(ds.Tables[0].Rows[0]["IssueDate"]));
                str = str.Replace("[RegNo]", Convert.ToString(ds.Tables[0].Rows[0]["RegNo"]));
                str = str.Replace("[FKRTOStateID]", Convert.ToString(ds.Tables[0].Rows[0]["RTOStateName"]));
                str = str.Replace("[RiskStartDate]", Convert.ToString(ds.Tables[0].Rows[0]["RiskStartDate"]));
                str = str.Replace("[RiskEndDate]", Convert.ToString(ds.Tables[0].Rows[0]["RiskEndDate"]));

                str = str.Replace("[FKInsCompanyID]", Convert.ToString(ds.Tables[0].Rows[0]["InsuranceCompanyName"]));
                str = str.Replace("[FKBrokerID]", Convert.ToString(ds.Tables[0].Rows[0]["BrokerName"]));
                str = str.Replace("[FKPolicyTypeID]", Convert.ToString(ds.Tables[0].Rows[0]["PolicyType"]));
                str = str.Replace("[FKSegmentID]", Convert.ToString(ds.Tables[0].Rows[0]["Segment"]));
                str = str.Replace("[FKSubSegmentID]", Convert.ToString(ds.Tables[0].Rows[0]["SubSegment"]));
                str = str.Replace("[FKFuelTypeID]", Convert.ToString(ds.Tables[0].Rows[0]["FuelType"]));
                str = str.Replace("[MfgName]", Convert.ToString(ds.Tables[0].Rows[0]["MfgName"]));
                str = str.Replace("[VehicleModel]", Convert.ToString(ds.Tables[0].Rows[0]["VehicleModel"]));
                str = str.Replace("[MfgYear]", Convert.ToString(ds.Tables[0].Rows[0]["MfgYear"]));
                str = str.Replace("[ODAmount]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["ODAmount"]).ToString("0.00"));
                str = str.Replace("[TPAmount]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["TPAmount"]).ToString("0.00"));
                str = str.Replace("[CPA]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["CPA"]).ToString("0.00"));
                str = str.Replace("[SubAmt]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["SubAmt"]).ToString("0.00"));
                str = str.Replace("[TaxAmt]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["TaxAmt"]).ToString("0.00"));
                str = str.Replace("[NetAmt]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["NetAmt"]).ToString("0.00"));

                str = str.Replace("[PaymentMode]", Convert.ToString(ds.Tables[0].Rows[0]["PaymentMode"]));
                str = str.Replace("[RecAmt]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["RecAmt"]).ToString("0.00"));
                str = str.Replace("[DueAmt]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["DueAmt"]).ToString("0.00"));

                str = str.Replace("[FKComissionPartID]", Convert.ToString(ds.Tables[0].Rows[0]["PartName"]));

                str = str.Replace("[Per]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["ComissionPer"]).ToString("0.00")+"%");
                str = str.Replace("[ComissionAmt]", TranCurrencySymbol + " " + Convert.ToDecimal(ds.Tables[0].Rows[0]["ComissionAmt"]).ToString("0.00"));

                str = str.Replace("[Remarks]", Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]));


            }
            return str;
        }
    }
}