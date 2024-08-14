using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using iTextSharp.text.html.simpleparser;
using iTextSharp.tool.xml;

namespace BLGeneral
{
    public class GenexFileOperation
    {
        public string CreatePDFFromHTMLFile(string HtmlStream, string FilePath,string FileName)
        {
            try
            {
                string TargetFile = FilePath+@"\"+FileName;
                

                using (FileStream stream = new FileStream(TargetFile, FileMode.Create))
                {
                    Document pdfDoc = new Document(PageSize.A4, 20f, 20f, 20f, 20f);
                    PdfWriter writer = PdfWriter.GetInstance(pdfDoc, stream);
                    pdfDoc.Open();
                    StringReader sr = new StringReader(HtmlStream);
                    XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
                    pdfDoc.Close();
                    stream.Close();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return FileName;
        }

       
    }
}
