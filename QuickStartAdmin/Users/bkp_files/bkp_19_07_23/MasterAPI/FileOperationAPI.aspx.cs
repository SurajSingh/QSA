using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
namespace QuickStartAdmin.Users.MasterAPI
{
    public partial class FileOperationAPI : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string ExportHTMLToPDF(string HTML, string FileName,Int64 FKPageID)
        {
            string result = "";

            if (!ClsLogin.ValidateLogin())
            {

                result = ClsLogin.GetErrorMsg("IO");
            }
            else
            {
                using (StringWriter sw = new StringWriter())
                {
                    using (HtmlTextWriter hw = new HtmlTextWriter(sw))
                    {
                        using (StringReader sr = new StringReader(HTML))
                        {
                            using (FileStream stream = new FileStream(AppDomain.CurrentDomain.BaseDirectory + "TempFile\\" + FileName + ".pdf", FileMode.Create))
                            {
                                Document pdfDoc = new Document(PageSize.LETTER.Rotate(), 10f, 10f, 10f, 0f);
                                HTMLWorker htmlparser = new HTMLWorker(pdfDoc);                               
                                PdfWriter.GetInstance(pdfDoc, stream);
                                pdfDoc.Open();
                                htmlparser.Parse(sr);
                                pdfDoc.Close();
                                stream.Close();
                                //HttpContext.Current.Response.Clear();
                            }
                        }
                    }
                }
                result=@"[{""Result"":""1"",""Msg"":""" + FileName+".pdf" + @"""}]";
            }

            return result;
        }
    }
}