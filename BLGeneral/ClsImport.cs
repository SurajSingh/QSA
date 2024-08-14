using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLGeneral
{
    public class ClsImport
    {
        public void SetError(DataSet dsResult, Int32 Result, string Msg)
        {
            if (dsResult.Tables.Count == 0)
            {
                dsResult.Tables.Add(new DataTable());
                dsResult.Tables[0].Columns.Add(new DataColumn("Result", typeof(Int32)));
                dsResult.Tables[0].Columns.Add(new DataColumn("Msg", typeof(string)));
                dsResult.AcceptChanges();
            }
            if (Msg != "")
            {
                DataRow dr = dsResult.Tables[0].NewRow();
                dr["Result"] = Result;
                dr["Msg"] = Msg;
                dsResult.Tables[0].Rows.Add(dr);
                dsResult.AcceptChanges();
            }


        }
       
       

        public DataTable PrepareImportData(Int64 FKImportTypeID, string SavedFileName, string FileType)
        {
            DataTable dtReadData = new DataTable();
            string FilePath = "";
            if (FKImportTypeID == 1 || FKImportTypeID == 2 || FKImportTypeID==3)
            {
                FilePath = "Users\\UserFiles\\Import\\Master\\";
            }
        

            if (FileType == "Excel")
            {
                dtReadData = ReadExcel(SavedFileName, FilePath);
            }
            else if (FileType == "CSV")
            {
                dtReadData = ReadCSV(SavedFileName, FilePath, true);
            }
            dtReadData.AcceptChanges();
            return dtReadData;

        }

        public DataTable ReadCSV(string SavedFileName, string FilePath, bool skipFirstRow)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + FilePath + SavedFileName;
            DataTable dtCSV = new DataTable();

            using (StreamReader reader = new StreamReader(path))
            {
                string line;
                int lineNum = 0;

                while ((line = reader.ReadLine()) != null)
                {
                    if (lineNum == 0 && skipFirstRow)
                    {
                        lineNum++;
                        continue;
                    }
                    else
                    {
                        lineNum++;

                    }
                    bool isNewRow = true;
                    DataRow NewRow = null;
                    string[] X = line.Split(',');
                    for (int i = 0; i < X.Length; i++)
                    {

                        if (!dtCSV.Columns.Contains("Col" + i))
                        {
                            dtCSV.Columns.Add(new DataColumn("Col" + i, typeof(string)));
                            dtCSV.AcceptChanges();

                        }

                    }
                    for (int i = 0; i < X.Length; i++)
                    {

                        if (isNewRow)
                        {
                            NewRow = dtCSV.NewRow();
                            isNewRow = false;
                            dtCSV.Rows.Add(NewRow);
                            dtCSV.AcceptChanges();
                        }
                        NewRow["Col" + i] = X[i];

                    }


                }
            }
            return dtCSV;

        }
        public DataTable ReadExcel(string SavedFileName, string FilePath)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + FilePath + SavedFileName;
            string fileext = Path.GetExtension(path);

            string conn = string.Empty;
            DataTable dtexcel = new DataTable();
            try
            {
                conn = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Extended Properties='Excel 12.0;HDR=Yes';"; //for above excel 2007 

                using (OleDbConnection con = new OleDbConnection(conn))
                {
                    con.Open();
                    DataTable dbSchema = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                    con.Close();
                    if (dbSchema == null || dbSchema.Rows.Count < 1)
                    {
                        throw new Exception("Error: Could not determine the name of the first worksheet.");
                    }
                    string firstSheetName = dbSchema.Rows[0]["TABLE_NAME"].ToString();
                    OleDbDataAdapter oleAdpt = new OleDbDataAdapter("select * from [" + firstSheetName + "]", con); //here we read data from sheet1  
                    oleAdpt.Fill(dtexcel); //fill excel data into dataTable  
                }
            }
            catch
            {
                conn = @"provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + path + ";Extended Properties='Excel 8.0;HRD=Yes;IMEX=1';"; //for below excel 2007  
                using (OleDbConnection con = new OleDbConnection(conn))
                {
                    con.Open();
                    DataTable dbSchema = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                    con.Close();
                    if (dbSchema == null || dbSchema.Rows.Count < 1)
                    {
                        throw new Exception("Error: Could not determine the name of the first worksheet.");
                    }
                    string firstSheetName = dbSchema.Rows[0]["TABLE_NAME"].ToString();
                    OleDbDataAdapter oleAdpt = new OleDbDataAdapter("select * from [" + firstSheetName + "]", con); //here we read data from sheet1  
                    oleAdpt.Fill(dtexcel); //fill excel data into dataTable  
                }

            }

            return dtexcel;

        }

        public int GetIndex(string column)
        {

            int retVal = 0;
            string col = column.ToUpper();
            for (int iChar = col.Length - 1; iChar >= 0; iChar--)
            {
                char colPiece = col[iChar];
                int colNum = colPiece - 64;
                retVal = retVal + colNum * (int)Math.Pow(26, col.Length - (iChar + 1));
            }
            return retVal;

        }
    }
}
