using Hangfire;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace BL.Classes.Scheduler
{
    internal static class HangfireScheduler
    {
        public static void ScheduleJob(Expression<Action> methodCall, TimeSpan delay, string jobId)
        {
            BackgroundJob.Schedule(() => methodCall.Compile().Invoke(), delay); // Schedules job without using jobId
        }

        public static void ScheduleRecurringJob(string recurringJobId, Expression<Action> methodCall, string cronExpression)
        {
            RecurringJob.AddOrUpdate(recurringJobId, methodCall, cronExpression);
        }

        public static void ScheduleRecurringJob<T>(string recurringJobId, Expression<Action<T>> methodCall, string cronExpression)
        {
            RecurringJob.AddOrUpdate<T>(recurringJobId, methodCall, cronExpression);
        }

        public static void DeleteRecurringJob(string jobId)
        {
            RecurringJob.RemoveIfExists(jobId);
        }
    }
}
