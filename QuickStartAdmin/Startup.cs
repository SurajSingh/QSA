using Microsoft.Owin;
using Owin;
using System;
using System.Threading.Tasks;
using Hangfire;
using Hangfire.SqlServer;
using System.Collections.Generic;
using System.Diagnostics;

[assembly: OwinStartup(typeof(QuickStartAdmin.Startup))]
namespace QuickStartAdmin
{
    public class Startup
    {
        private IEnumerable<IDisposable> GetHangfireServers()
        {
            Hangfire.GlobalConfiguration.Configuration
                .SetDataCompatibilityLevel(CompatibilityLevel.Version_180)
                .UseSimpleAssemblyNameTypeSerializer()
                .UseRecommendedSerializerSettings()
                .UseSqlServerStorage(System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConStrHangfire"].ConnectionString);

            yield return new BackgroundJobServer();
        }

        public void Configuration(IAppBuilder app)
        {
            app.UseHangfireAspNet(GetHangfireServers);
            app.UseHangfireDashboard();

            //Let's also create a sample background job
            //BackgroundJob.Enqueue(() => Debug.WriteLine("Hello world from Hangfire!"));

        }
    }
}
