using QuickStartAdmin.Classes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuickStartAdmin.Users
{
    public partial class Upload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!ClsLogin.ValidateLogin())
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>LogoutParent();alert('Session Out!');</script>", false);
                return;
            }
            if (ClsLogin.ValidateLogin() && IsPostBack && FileUpload1.PostedFile != null)
            {

                if (FileUpload1.PostedFile.FileName.Length > 0)
                {

                    string filename = "", originalfname = "";
                   
                    int fileSize = FileUpload1.PostedFile.ContentLength;
                    string strfilesize = "";

                    if (fileSize > 250000)
                        strfilesize = (fileSize / 1024).ToString() + " KB";
                    else
                    {
                        strfilesize = (fileSize).ToString() + " Byte";
                    }
                    try
                    {
                        var Result = 1;
                        var Msg = "";
                        string path = "";
                        originalfname = FileUpload1.PostedFile.FileName;
                        string date = DateTime.Now.ToFileTimeUtc().ToString();
                       
                        String extension = Path.GetExtension(FileUpload1.PostedFile.FileName);
                        if (hidFileType.Value != "")
                        {
                            string StrFileType = hidFileType.Value.ToUpper();
                            if (StrFileType == "EXCEL")
                            {
                                StrFileType = ".XLSX,.XLS,.XLSM";
                            }
                            else if (StrFileType == "CSV")
                            {
                                StrFileType = ".CSV";

                            }
                            if (StrFileType.IndexOf(extension.ToUpper()) < 0)
                            {
                                Result = 0;
                                Msg = "Invalid File Type";
                            }
                        }
                        if (Result == 1)
                        {

                            filename = date + extension;
                            
                            if (hidUploadType.Value.ToString() == "Party")
                            {
                                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\UserFiles\\Party\\";

                            }
                            else if (hidUploadType.Value.ToString() == "Profile")
                            {
                                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\UserFiles\\Profile\\";

                            }                            
                            else if (hidUploadType.Value == "Logo")
                            {
                                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\UserFiles\\Logo\\";
                            }
                            else if (hidUploadType.Value == "ImportMaster")
                            {
                                path = AppDomain.CurrentDomain.BaseDirectory + "\\Users\\UserFiles\\Import\\Master\\";
                            }
                            else if (hidUploadType.Value == "Transaction")
                            {
                                path = AppDomain.CurrentDomain.BaseDirectory + "\\webfiles\\transaction\\";
                            }
                            else if (hidUploadType.Value == "Item")
                            {
                                path = AppDomain.CurrentDomain.BaseDirectory + "\\webfiles\\itemimg\\";
                            }
                            if (path != "")
                            {
                                                           
                                FileUpload1.SaveAs(path+filename);

                            }
                            else
                            {
                                Result = 0;
                                Msg = "Invalid Operation";

                            }

                        }

                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>callFileClientFunction('" + filename + "','" + strfilesize + "','" + originalfname + "','" + extension + "','" + Result + "','" + Msg + "');</script>", false);


                    }
                    catch (Exception ex)
                    {
                        divErrormsg.InnerHtml = ex.Message;
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>callFileClientFunction('" + filename + "','" + "" + "','" + "" + "','" + "" + "','" + "0" + "','" + "Server Error" + "');</script>", false);
                        

                    }

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Please select a file');</script>", false);
                    return;
                }


            }
        }
    }
}