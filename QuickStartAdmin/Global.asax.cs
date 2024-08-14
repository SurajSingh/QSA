using Aspose.Pdf.Forms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
//using Hangfire;
//using Hangfire.SqlServer;
using System.Diagnostics;

namespace QuickStartAdmin
{
    public class Global : HttpApplication
    {


        void Application_Start(object sender, EventArgs e)
        {
            BL.DAL.clsDAL.connString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConStr"].ConnectionString;

            /*
            RouteTable.Routes.MapHttpRoute(
            name: "NeosolApi",
            routeTemplate: "api/{controller}/{id}",
            defaults: new { id = System.Web.Http.RouteParameter.Optional }
            );
            */

            // Controller Only
            // To handle routes like `/api/VTRouting`
            RouteTable.Routes.MapHttpRoute(
                name: "ControllerOnly",
                routeTemplate: "api/{controller}"
            );

            // Controllers with Actions
            // To handle routes like `/api/VTRouting/route`
            RouteTable.Routes.MapHttpRoute(
                name: "ControllerAndAction",
                routeTemplate: "api/{controller}/{action}"
            );

            // Controller with ID
            // To handle routes like `/api/VTRouting/1`
            RouteTable.Routes.MapHttpRoute(
                name: "ControllerAndId",
                routeTemplate: "api/{controller}/{id}",
                defaults: null,
                constraints: new { id = @"^\d+$" } // Only integers 
            );

            

            // Controllers with Actions
            // To handle routes like `/api/VTRouting/route`
            RouteTable.Routes.MapHttpRoute(
                name: "ControllerAndActionAndId",
                routeTemplate: "api/{controller}/{action}/{id}",
                defaults: null,
                constraints: new { id = @"^\d+$" }
            );

            //HangfireAspNet.Use(GetHangfireServers);

            // Let's also create a sample background job
            //BackgroundJob.Enqueue(() => Debug.WriteLine("Hello world from Hangfire!"));
        }
    }
}