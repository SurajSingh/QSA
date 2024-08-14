using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BL.Classes.Billing
{
    public enum BillingFrequency
    {
        WEEKELY = 1,
        BI_WEEKELY = 2,
        SEMI_MONTHLY = 3,
        MONTHLY = 4,
        BI_MONTHLY = 5,
        SEMI_ANNUALLY = 6,
        ANNUALLY = 7,
        UPON_LIMIT = 8
    }

    public class SkipBillingCycleCalculator
    {
        private readonly decimal _threshold;
        private readonly BillingFrequency _billingFrequency;
        private readonly DateTime _projectStartDate;

        public SkipBillingCycleCalculator(decimal threshold, BillingFrequency billingFrequency, DateTime projectStartDate)
        {
            _threshold = threshold;
            _billingFrequency = billingFrequency;
            _projectStartDate = projectStartDate;
        }

        public decimal CalculateInvoiceLimit(int cyclesSkipped)
        {
            decimal adjustedThreshold = _threshold;
            Console.WriteLine($"adjustedThreshold: {adjustedThreshold}");

            if (cyclesSkipped > 0)
            {
                //adjustedThreshold *= (decimal)Math.Pow(2, cyclesSkipped);
                adjustedThreshold *= (decimal) cyclesSkipped;
                //Console.WriteLine($"adjustedThreshold: {adjustedThreshold}");
            }

            return adjustedThreshold;
        }

        public int CalculateSkippedCycles(DateTime lastInvoiceDate, DateTime today)
        {
            if (lastInvoiceDate < _projectStartDate)
                lastInvoiceDate = _projectStartDate;

            int cyclesSkipped = 0;
            TimeSpan difference = today - lastInvoiceDate;

            switch (_billingFrequency)
            {
                case BillingFrequency.WEEKELY:
                    cyclesSkipped = (int)(difference.TotalDays / 7);
                    break;
                case BillingFrequency.BI_WEEKELY:
                    cyclesSkipped = (int)(difference.TotalDays / 14);
                    break;
                case BillingFrequency.SEMI_MONTHLY:
                    cyclesSkipped = ((today.Year - lastInvoiceDate.Year) * 24) + ((today.Month - lastInvoiceDate.Month) * 2) + (today.Day >= 15 && lastInvoiceDate.Day < 15 ? 1 : 0);
                    break;
                case BillingFrequency.MONTHLY:
                    cyclesSkipped = ((today.Year - lastInvoiceDate.Year) * 12) + today.Month - lastInvoiceDate.Month;
                    break;
                case BillingFrequency.BI_MONTHLY:
                    cyclesSkipped = ((today.Year - lastInvoiceDate.Year) * 6) + ((today.Month - lastInvoiceDate.Month) / 2);
                    break;
                case BillingFrequency.SEMI_ANNUALLY:
                    cyclesSkipped = ((today.Year - lastInvoiceDate.Year) * 2) + ((today.Month - 1) / 6) - ((lastInvoiceDate.Month - 1) / 6);
                    break;
                case BillingFrequency.ANNUALLY:
                    cyclesSkipped = today.Year - lastInvoiceDate.Year;
                    break;
                case BillingFrequency.UPON_LIMIT:
                    // no logic implemented;
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }

            return Math.Max(0, cyclesSkipped);
        }
    }
}
