using BL.Master;
using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class Employees : System.Web.UI.Page
    {
        public string PageVersion = "23062022";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.Employees, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.Employees).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.Employees).ToString();

            }
        }



       

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetRoleGroupData(Int64 PKRoleGroupID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Employees, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blUser objda = new blUser();
                ClsGeneral objgen = new ClsGeneral();

                objda.PKRoleGroupID = PKRoleGroupID;
                objda.GroupName = "";
                objda.OrgTypeID = "C";
                objda.FKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);

                DataSet ds = objda.GetAllRoleGroup();
                if (PKRoleGroupID == 0)
                    result = objgen.SerializeToJSON(ds.Tables[0]);
                else
                    result = objgen.SerializeToJSON(ds.Tables[1]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveRoleGroup(Int64 PKRoleGroupID, string rolename, string roleid, string rolenid, string isview, string isadd, string isedit, string isdelete)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Employees, ClsRoles.IsAdd))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {

                string[] roleid1 = roleid.Split('#');
                string[] isview1 = isview.Split('#');
                string[] isadd1 = isadd.Split('#');
                string[] isedit1 = isedit.Split('#');
                string[] isdelete1 = isdelete.Split('#');

                DataSet DsRoles = new DataSet();
                DsRoles.Tables.Add(new DataTable());
                DsRoles.Tables[0].Columns.Add(new DataColumn("FKRoleID", typeof(Int64)));
                DsRoles.Tables[0].Columns.Add(new DataColumn("IsView", typeof(bool)));
                DsRoles.Tables[0].Columns.Add(new DataColumn("IsAdd", typeof(bool)));
                DsRoles.Tables[0].Columns.Add(new DataColumn("IsEdit", typeof(bool)));
                DsRoles.Tables[0].Columns.Add(new DataColumn("IsDelete", typeof(bool)));

                for (int i = 0; i < roleid1.Length; i++)
                {

                    if (roleid1[i] != "")
                    {
                        DataRow drRole = DsRoles.Tables[0].NewRow();
                        drRole["FKRoleID"] = roleid1[i];
                        drRole["IsView"] = isview1[i] == "1" ? true : false;
                        drRole["IsAdd"] = isadd1[i] == "1" ? true : false;
                        drRole["IsEdit"] = isedit1[i] == "1" ? true : false;
                        drRole["IsDelete"] = isdelete1[i] == "1" ? true : false;
                        DsRoles.Tables[0].Rows.Add(drRole);
                    }
                }
                blUser objda = new blUser();
                ClsGeneral objgen = new ClsGeneral();
                objda.PKRoleGroupID = PKRoleGroupID;
                objda.GroupName = rolename;
                objda.OrgTypeID = "C";
                objda.DtRoleXML = DsRoles.GetXml();
                objda.FKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Employees;

                DataSet dsResult = objda.InsertRoleGroup();
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }
            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteRoleGroup(Int64 PKRoleGroupID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Employees, PKRoleGroupID == 0 ? ClsRoles.IsDelete : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blUser objda = new blUser();
                ClsGeneral objgen = new ClsGeneral();

                objda.PKRoleGroupID = PKRoleGroupID;
                objda.FKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Employees;
                DataSet dsResult = objda.DeleteRoleGroup();
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string ValidateLoginID(string LoginID, Int64 PKUserID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Employees, ClsRoles.IsAdd))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blUser objda = new blUser();
                ClsGeneral objgen = new ClsGeneral();
                objda.LoginID = LoginID;
                objda.PKUserID = PKUserID;
                DataSet ds = objda.ValidateUserID();
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetDepartment()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Employees, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();


                DataSet ds = objda.GetDepartment(0, "", Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetDesignation()
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Employees, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blMaster objda = new blMaster();
                ClsGeneral objgen = new ClsGeneral();

                DataSet ds = objda.GetDesignation(0, "", Convert.ToInt64(HttpContext.Current.Session["OrgID"]));
                result = objgen.SerializeToJSON(ds.Tables[0]);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string getAllRoleText()
        {
            string str = "";
            if (ClsLogin.ValidateLogin())
            {

                blMaster objda = new blMaster();

                DataSet ds = objda.GetRolesByCompany(Convert.ToInt64(HttpContext.Current.Session["OrgID"]), Convert.ToString(HttpContext.Current.Session["OrgType"]));
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataView view = new DataView(ds.Tables[0]);
                    DataTable distinctValues = view.ToTable(true, "RoleGroup");
                    int trid = 0;
                    for (int i = 0; i < distinctValues.Rows.Count; i++)
                    {
                        str += "<tr class='trrolegroup' style='background: #e6e6e6;'><th colspan='6'>" + distinctValues.Rows[i][0].ToString() + "</th></tr>";


                        DataRow[] Dr = ds.Tables[0].Select("RoleGroup='" + distinctValues.Rows[i][0].ToString() + "'");


                        for (int j = 0; j < Dr.Length; j++)
                        {
                            str += "<tr id='trinv_" + trid.ToString() + "'><td style='text-align:center; width:70px;'><span class='checkcustom chkitem'><span><input type='checkbox' id='chkrecord" + trid + "' value='" + Dr[j]["PKRoleID"].ToString() + "' /></span></span><input type='hidden' id='hidrolegrouoid" + trid + "' value='' /></td>";

                            str += "<td>" + Dr[j]["RoleName"].ToString() + "</td>";

                            if (!Convert.ToBoolean(Dr[j]["IsView"]))
                                str += "<td width='70'><input type='checkbox' id='chkview" + trid + "' style='display:none;'   disabled/></td>";
                            else
                                str += "<td style='text-align:center;width:70px;'><span class='checkcustom chkiteminner'><span><input type='checkbox' id='chkview" + trid + "'   /></span></span></td>";

                            if (!Convert.ToBoolean(Dr[j]["IsAdd"]))
                                str += "<td  width='70'><input type='checkbox' id='chkadd" + trid + "' style='display:none;'  disabled/></td>";
                            else
                                str += "<td style='text-align:center;width:70px;'><span class='checkcustom chkiteminner'><span><input type='checkbox' id='chkadd" + trid + "'   /></span></span></td>";

                            if (!Convert.ToBoolean(Dr[j]["IsEdit"]))
                                str += "<td><input type='checkbox' id='chkedit" + trid + "'  style='display:none;' disabled/></td>";
                            else
                                str += "<td style='text-align:center;width:70px;'><span class='checkcustom chkiteminner'><span><input type='checkbox' id='chkedit" + trid + "'   /></span></span></td>";

                            if (!Convert.ToBoolean(Dr[j]["IsDelete"]))
                                str += "<td><input type='checkbox' id='chkdelete" + trid + "' style='display:none;'  disabled/></td>";
                            else
                                str += "<td style='text-align:center;width:70px;'><span class='checkcustom chkiteminner'><span><input type='checkbox' id='chkdelete" + trid + "'   /></span></span></td>";
                            str += "</tr>";
                            trid++;

                        }

                    }
                }
            }










            return str;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetData(Int64 PageSize, Int64 OffSet, string SortBy, string SortDir, Int64 PKUserID, string ActiveStatus,string Name, Int64 FKDeptID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Employees, ClsRoles.IsView))
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                blUser objda = new blUser();
                ClsGeneral objgen = new ClsGeneral();

                objda.PKUserID = PKUserID;
                objda.FKRoleGroupID = 0;
                objda.Name = Name;
                objda.FKDeptID = FKDeptID;
                objda.ActiveStatus = ActiveStatus;
                objda.FKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                objda.FKParentID = 0;
                objda.FKDesigID = 0;
                objda.OrgTypeID = "C";
                objda.ForAppointment = false;
                DataSet ds = objda.GetUser(PageSize, OffSet, SortBy, SortDir);
               
                result = objgen.SerializeToJSON(ds);
            }

            return result;
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveData(Int64 PKUserID, string LoginID, string EmailID, string PWD, string FName, string MName, string LName, string EnrollNo, object DOB, string Gender, string MobNo, string Phone1, string Phone2, string AddressTitle, string Address1, string Address2, Int64 FKTahsilID, Int64 FKCityID, Int64 FKStateID, Int64 FKCountryID, string ZIP, object JoinDate, object ReleasedDate, Int64 FKManagerID, Int64 FKSubmitToID, string RoleType, Int64 FKRoleGroupID, Int64 FKDeptID, Int64 FKDesigID, Int64 FKTimeZoneID, string Remark, bool IsAppointment, Int64 FKDashboardID, string ActiveStatus, decimal BillRate, decimal PayRate, decimal OverTimeBillRate, decimal OverTimePayrate, decimal OverheadMulti, Int64 FKCurrencyID, string PayPeriod, decimal SalaryAmount)
        {
            string result = "";
            int status = 1;
            if (EmailID == "" || LoginID == "" || PWD == "" || FName == "" || LName == "" || RoleType == "" || ActiveStatus == "")
            {
                status = 0;
                result = ClsLogin.GetErrorMsg("V");
            }
            if (status == 1)
            {
                if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Employees, PKUserID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
                {
                    status = 0;
                    result = ClsLogin.GetErrorMsg("IL");
                }
            }
            if (status == 1)
            {
                blUser objda = new blUser();
                ClsGeneral objgen = new ClsGeneral();

                objda.PKUserID = PKUserID;
                objda.LoginID = LoginID;
                objda.EmailID = EmailID;
                objda.PWD = PWD;
                objda.FName = FName;
                objda.MName = MName;
                objda.LName = LName;
                objda.EnrollNo = EnrollNo;
              
                if (Convert.ToString(DOB) == "")
                {
                    objda.DOB = null;
                }
                else
                {
                    objda.DOB = (DateTime.ParseExact(DOB.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }
                objda.Gender = Gender;
                objda.MobNo = MobNo;
                objda.Phone1 = Phone1;
                objda.Phone2 = Phone2;
                objda.AddressTitle = AddressTitle;
                objda.Address1 = Address1;
                objda.Address2 = Address2;
                objda.FKTahsilID = FKTahsilID;
                objda.FKCityID = FKCityID;
                objda.FKStateID = FKStateID;
                objda.FKCountryID = FKCountryID;
                objda.ZIP = ZIP;
                if (Convert.ToString(JoinDate) == "")
                {
                    objda.JoinDate = null;
                }
                else
                {
                    objda.JoinDate = (DateTime.ParseExact(JoinDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }
                if (Convert.ToString(ReleasedDate) == "")
                {
                    objda.ReleasedDate = null;
                }
                else
                {
                    objda.ReleasedDate = (DateTime.ParseExact(ReleasedDate.ToString(), Convert.ToString(HttpContext.Current.Session["DateFormat"]), CultureInfo.InvariantCulture));

                }
               
                objda.FKManagerID = FKManagerID;
                objda.FKSubmitToID = FKSubmitToID;               
                objda.RoleType = RoleType;
                objda.FKRoleGroupID = FKRoleGroupID;                
                objda.FKDeptID = FKDeptID;
                objda.FKDesigID = FKDesigID;
                objda.FKTimeZoneID = FKTimeZoneID;
                objda.Remark = Remark;
                objda.ForAppointment = IsAppointment;
                objda.IsDefaultUser =false;
                objda.FKDashboardID = FKDashboardID;
                objda.ActiveStatus = ActiveStatus;
                objda.BillRate = BillRate;
                objda.PayRate = PayRate;
                objda.OverTimeBillRate = OverTimeBillRate;
                objda.OverTimePayrate = OverTimePayrate;
                objda.OverheadMulti = OverheadMulti;
                objda.FKCurrencyID = FKCurrencyID;
                objda.PayPeriod = PayPeriod;
                objda.SalaryAmount = SalaryAmount;
                objda.FKCompanyID = Convert.ToInt64(HttpContext.Current.Session["OrgID"]);
                objda.OrgTypeID = "C";
                objda.FKParentID = 0;
                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Employees;
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();



                DataSet dsResult = objda.InsertUser();
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string DeleteData(Int64 PKUserID)
        {
            string result = "";
            if (!ClsLogin.ValidateLogin() || !ClsLogin.ValidateRole((Int32)ClsRoles.UserRoles.Employees, PKUserID == 0 ? ClsRoles.IsAdd : ClsRoles.IsEdit))
            {

                result = ClsLogin.GetErrorMsg("IL");
            }
            else
            {
                blUser objda = new blUser();
                ClsGeneral objgen = new ClsGeneral();

                objda.PKUserID = PKUserID;

                objda.FKUserID = Convert.ToInt64(HttpContext.Current.Session["UserID"]);
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.FKPageID = (Int64)ClsPages.WebPages.Employees;
                DataSet dsResult = objda.DeleteUser();
                result = objgen.SerializeToJSON(dsResult.Tables[0]);

            }

            return result;

        }
    }
}