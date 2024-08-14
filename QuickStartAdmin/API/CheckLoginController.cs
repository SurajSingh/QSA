using BL.Master;
using BLGeneral;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace QuickStartAdmin.API
{
    public class CheckLoginController : ApiController
    {
        // GET api/<controller>/5
        public HttpResponseMessage Get(string LoginID,string TokenID)
        {
            DataSet ds = new DataSet();
            blUser objda = new blUser();
            HttpStatusCode httpStatusCode = HttpStatusCode.OK;
            if (LoginID!="" && TokenID != "")
            {
                objda.LoginID = LoginID;
                objda.PWD = TokenID;
                objda.RecordType = "Check";
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                ds = objda.LoginWithToken();
            }
            else
            {
                httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Request.CreateResponse(httpStatusCode, ds);
        }
    }
}