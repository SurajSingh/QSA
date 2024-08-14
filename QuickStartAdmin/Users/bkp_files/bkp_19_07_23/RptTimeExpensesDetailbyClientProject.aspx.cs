using BLGeneral;
using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class RptTimeExpensesDetailbyClientProject : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (ClsLogin.ValidateRedirect((Int32)ClsRoles.UserRoles.TimeExpensesDetailbyClientProject, ""))
            {
                ((HiddenField)this.Master.FindControl("HidPageRoleID")).Value = ((Int32)ClsRoles.UserRoles.TimeExpensesDetailbyClientProject).ToString();
                ((HiddenField)this.Master.FindControl("HidPageID")).Value = ((Int32)ClsPages.WebPages.TimeExpensesDetailbyClientProject).ToString();
            }
        }
    }
}