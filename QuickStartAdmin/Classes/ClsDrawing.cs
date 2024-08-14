using iTextSharp.text.pdf;
using System.Drawing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QRCoder;
using System.IO;

namespace QuickStartAdmin.Classes
{
    public class ClsDrawing
    {
        public System.Drawing.Image CreateBarcode(string data)
        {
            // iTextShirp
            //Bitmap barCode = new Bitmap(1, 1);
            Barcode128 code128 = new Barcode128(); // barcode type
            code128.Code = data;
            code128.CodeType = Barcode.CODE128;
            code128.ChecksumText = true;
            code128.GenerateChecksum = true;
            System.Drawing.Image barCode = code128.CreateDrawingImage(System.Drawing.Color.Black, System.Drawing.Color.White);
            //barCode.Save(Server.MapPath(“~/barcode.gif”), System.Drawing.Imaging.ImageFormat.Gif); //save file
            return barCode;
        }
        public byte[] CreateQRCode(string data)
        {
            byte[] byteImage = null;
            string code = data;
            QRCodeGenerator qrGenerator = new QRCodeGenerator();
            QRCodeGenerator.QRCode qrCode = qrGenerator.CreateQrCode(code, QRCodeGenerator.ECCLevel.Q);
            System.Web.UI.WebControls.Image imgBarCode = new System.Web.UI.WebControls.Image();
            imgBarCode.Height = 150;
            imgBarCode.Width = 150;
            using (Bitmap bitMap = qrCode.GetGraphic(20))
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    bitMap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                    byteImage = ms.ToArray();
                    
                }
                
            }
            return byteImage;


        }
        public static byte[] ImageToByte(System.Drawing.Image img)
        {
            ImageConverter converter = new ImageConverter();
            return (byte[])converter.ConvertTo(img, typeof(byte[]));
        }
    }
}