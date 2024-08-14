using BLGeneral;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;

namespace QuickStartAdmin.Classes
{
    public class ClsCommon
    {
        public string GetMenuHTML(Int64 FKUserID, DataTable dtPage)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            string UserType = Convert.ToString(HttpContext.Current.Session["UserType"]);
            if (dtPage.Rows.Count > 0)
            {
                DataRow[] rows = dtPage.Select("FKParentID=0", "sno");
                foreach (DataRow dr in rows)
                {
                    Int64 FKParentID = Convert.ToInt64(dr["PKPageID"]);
                    DataRow[] rowsChild =null;
                    
                    rowsChild = dtPage.Select("IsPageLink=1 And FKParentID<>0 And FKParentID=" + FKParentID, "sno");

                    string StrPageID = Convert.ToString(dr["PageName"]).Replace(" ", "");


                    if (rowsChild!=null && rowsChild.Length > 0)
                    {
                        sb.Append("<li>");
                        sb.Append("<a href='javascript:void(0);' class='has-arrow waves-effect'>" + Convert.ToString(dr["IconHTML"]));
                        sb.Append("<span>");
                        sb.Append(Convert.ToString(dr["PageName"]));
                        sb.Append("</span></a>");
                    }
                    else
                    {
                        sb.Append("<li>");
                        string PageLink = Convert.ToString(dr["PageLink"]);
                        string LinkTarget = "";                       
                        sb.Append("<a "+ LinkTarget + " href='" + PageLink + "'>" + Convert.ToString(dr["IconHTML"]) + "<span>" + Convert.ToString(dr["PageName"]) + "</span></a>");
                    }

                    //Sub Menu
                    if (rowsChild != null && rowsChild.Length > 0)
                    {
                        sb.Append("<ul class='sub-menu collapse' aria-expanded='true'>");
                        foreach (DataRow drChild in rowsChild)
                        {
                            string strTarget = "";
                            Int64 PKPageID = Convert.ToInt64(drChild["PKPageID"]);                            
                           
                            DataRow[] rowsSubChild = dtPage.Select("IsPageLink=1 And FKParentID<>0 And FKParentID=" + PKPageID, "sno");

                            if (rowsSubChild.Length > 0)
                            {
                                sb.Append("<li><a class='has-arrow waves-effect' href='" + Convert.ToString(drChild["PageLink"]) + "' " + strTarget + ">" + Convert.ToString(drChild["PageName"]) + "</a>");

                                sb.Append("<ul class='sub-menu collapse' aria-expanded='true'>");
                                foreach (DataRow drSubChild in rowsSubChild)
                                {
                                    sb.Append("<li><a href='" + Convert.ToString(drSubChild["PageLink"]) + "' " + strTarget + "><i class='uil-angle-right'></i><span>" + Convert.ToString(drSubChild["PageName"]) + "</span></a>");

                                    sb.Append("</li>");
                                }
                                sb.Append("</ul>");

                            }
                            else
                            {
                                sb.Append("<li><a href='" + Convert.ToString(drChild["PageLink"]) + "' " + strTarget + ">" + Convert.ToString(drChild["PageName"]) + "</a>");

                            }



                            sb.Append("</li>");

                        }
                        sb.Append("</ul>");

                    }
                    sb.Append("</li>");

                }
            }

            return sb.ToString();
        }

        public bool DownloadVirturalFile(string uploadfile, string downloadfile, string FilePath)
        {
            bool status = true;

            //Location of orginal file is LIBRARY folder, Set here location of your file
            string path = FilePath + uploadfile; //get physical file path from server
            string name = Path.GetFileName(path); //get file name
            string type = "";
            string ext = Path.GetExtension(path); //get file extension

            if (ext != null)
            {
                switch (ext.ToLower())
                {
                    case ".mp3":
                        type = "audio/MPEG";
                        break;
                    case ".wav":
                        type = "audio/x-wav";
                        break;
                    case ".mp2":
                    case ".mpa":
                    case ".mpe":
                    case ".mpeg":
                    case ".mpv2":
                        type = "video/mpeg";
                        break;
                    case ".avi":
                        type = "video/x-msvideo";
                        break;
                    case ".htm":
                    case ".html":
                        type = "text/HTML";
                        break;

                    case ".txt":
                        type = "text/plain";
                        break;
                    case ".png":
                        type = "image/PNG";
                        break;
                    case ".gif":
                        type = "image/GIF";
                        break;
                    case ".jpg":
                        type = "image/JPG";
                        break;
                    case ".jpeg":
                        type = "image/JPEG";
                        break;
                    case ".pdf":
                        type = "Application/pdf";
                        break;

                    case ".doc":
                    case ".docx":
                    case ".rtf":
                        type = "Application/msword";
                        break;
                    case ".xls":
                    case ".xlsx":
                    case ".csv":
                        type = "Application/msexcel";
                        break;
                    default:
                        type = "";
                        break;
                }
            }
            downloadfile = HttpContext.Current.Server.UrlDecode(downloadfile);
            HttpContext.Current.Response.AppendHeader("content-disposition", "attachment; filename=\"" + downloadfile + "\"");

            if (type != "")
                HttpContext.Current.Response.ContentType = type;

            try
            {


                HttpContext.Current.Response.WriteFile(path);
                HttpContext.Current.Response.End(); //give POP to user for file downlaod
                status = true;
            }
            catch (Exception ex)
            {
                string str = ex.ToString();
                status = false;
            }


            return status;



        }
    }

}