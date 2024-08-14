using BL.Master;
using BLGeneral;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using static iTextSharp.text.pdf.events.IndexEvents;

namespace QuickStartAdmin.API
{
    public class lSinginRequest
    {
        public string loginID { get; set; }

        public string password { get; set; }
    }

    public class lSinginResponse
    {
        public string userName { get; set; }

        public string empId { get; set; }

        public string emailID { get; set; }
    }

    [RoutePrefix("api/login")]


    public class LoginController : ApiController
    {
        
        // GET api/<controller>/5
        [Route("SignIn")]
        [HttpPost]
        public HttpResponseMessage SignIn(lSinginRequest pRequest)
        {
            DataSet ds = new DataSet();
            lSinginResponse response = new lSinginResponse();
            blUser objda = new blUser();
            HttpStatusCode httpStatusCode = HttpStatusCode.OK;
            if (pRequest.loginID!= "" && pRequest.password != "")
            {
                objda.LoginID = pRequest.loginID;
                //objda.PWD = BLGeneral.ClsSecurity.Encrypt(pRequest.password);
                objda.PWD = pRequest.password;
                objda.IPAddress = Classes.ClsLogin.GetRequestIP();
                objda.MACAdd = ClsGeneral.GetRequestMACAddr();
                ds = objda.Login();
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 && ds.Tables[0].Rows[0]["Result"].ToString() == "1")
                {

                    response.empId =  ds.Tables[0].Rows[0]["PKUserID"].ToString();
                    response.userName = ds.Tables[0].Rows[0]["Name"].ToString();
                    response.emailID = ds.Tables[0].Rows[0]["emailID"].ToString();

                }
                else
                {
                    httpStatusCode = HttpStatusCode.NotFound;
                }
                


            }
            else
            {
                httpStatusCode = HttpStatusCode.BadRequest;
            }
            return Request.CreateResponse<lSinginResponse>(httpStatusCode, response);
        }
    }
}