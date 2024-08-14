using System;
using System.Globalization;

namespace BL.Classes.Billing
{
    public class BillingFrequencyCalculator
    {
        public const int WEEKELY = 1;
        public const int BI_WEEKELY = 2;
        public const int SEMI_MONTHLY = 3;
        public const int MONTHLY = 4;
        public const int BI_MONTHLY = 5;
        public const int SEMI_ANNUALLY = 6;
        public const int ANNUALLY = 7;
        public const int UPON_LIMIT = 8;

        public DateTime CalculateNextBillingDate(DateTime lastBillingDate, int billingFrequency)
        {
            DateTime nextBillingDate = lastBillingDate;

            switch (billingFrequency)
            {
                case WEEKELY:
                    nextBillingDate = GetLastDayOfWeek(lastBillingDate);
                    break;
                case BI_WEEKELY:
                    nextBillingDate = GetLastDayOfWeek(lastBillingDate.AddDays(14));
                    break;
                case SEMI_MONTHLY:
                    nextBillingDate = lastBillingDate.AddDays(15);
                    break;
                case MONTHLY:
                    nextBillingDate = GetLastDayOfMonth(lastBillingDate.AddMonths(1));
                    break;
                case BI_MONTHLY:
                    nextBillingDate = GetLastDayOfMonth(lastBillingDate.AddMonths(2));
                    break;
                case SEMI_ANNUALLY:
                    nextBillingDate = GetLastDayOfMonth(lastBillingDate.AddMonths(6));
                    break;
                case ANNUALLY:
                    nextBillingDate = GetLastDayOfYear(lastBillingDate.AddYears(1));
                    break;
                case UPON_LIMIT:
                    // Handle special case for "uponlimit"
                    nextBillingDate = CalculateNextBillingDateUponLimit(lastBillingDate);
                    break;
                default:
                    throw new ArgumentException("Invalid billing frequency");
            }

            return nextBillingDate;
        }

        private DateTime GetLastDayOfWeek(DateTime date)
        {
            DayOfWeek lastDay = DayOfWeek.Saturday;
            int daysUntilLastDay = (int)lastDay - (int)date.DayOfWeek;
            return date.AddDays(daysUntilLastDay > 0 ? daysUntilLastDay : 7 + daysUntilLastDay);
        }

        private DateTime GetLastDayOfMonth(DateTime date)
        {
            return new DateTime(date.Year, date.Month, DateTime.DaysInMonth(date.Year, date.Month));
        }

        private DateTime GetLastDayOfYear(DateTime date)
        {
            return new DateTime(date.Year, 12, 31);
        }

        private DateTime CalculateNextBillingDateUponLimit(DateTime lastBillingDate)
        {
            // Implement logic for "uponlimit"
            // Placeholder implementation:
            return lastBillingDate.AddMonths(1);
        }
    }
}

