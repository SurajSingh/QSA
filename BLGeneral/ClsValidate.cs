using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLGeneral
{
    public class ClsValidate
    {
        public static bool IsDate(String date,string DateFormat)
        {
            try
            {
                DateTime dt = DateTime.ParseExact(Convert.ToString(date), DateFormat, CultureInfo.InvariantCulture);
               
                return true;
            }
            catch
            {
                return false;
            }
        }
        public static bool IsNumeric(object Expression)
        {
            double retNum;

            bool isNum = Double.TryParse(Convert.ToString(Expression), System.Globalization.NumberStyles.Any, System.Globalization.NumberFormatInfo.InvariantInfo, out retNum);
            return isNum;
        }
        public static bool IsInteger(object Expression)
        {
            Int64 retNum;

            bool isNum = Int64.TryParse(Convert.ToString(Expression), System.Globalization.NumberStyles.Any, System.Globalization.NumberFormatInfo.InvariantInfo, out retNum);
            return isNum;
        }
        public static bool IsBool(object Expression)
        {
            bool retNum;

            bool isNum = bool.TryParse(Convert.ToString(Expression), out retNum);
            return isNum;
        }
    }
}
