using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;

namespace RegisterUser
{
    public class Common
    {
        public static string ConnStr = getConnStr();
        public static string getConnStr()
        {
            try
            {
                return ConfigurationManager.ConnectionStrings["ConnStr"].ToString();
            }
            catch(Exception ex)
            {
                return ex.Message;
            }
        }
        public static string GenerateMD5(string input)
        {

            using (System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create())
            {
                byte[] inputBytes =Encoding.ASCII.GetBytes(input);
                byte[] hashBytes = md5.ComputeHash(inputBytes);

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < hashBytes.Length; i++)
                {
                    sb.Append(hashBytes[i].ToString("X2"));
                }
                return sb.ToString();
            }
        }
        public static DataSet GetDataSet(string sp, List<SqlParameter> sqlParams)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(sp, con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        if (sqlParams != null)
                        {
                            foreach (IDataParameter para in sqlParams)
                            {
                                cmd.Parameters.Add(para);
                            }
                        }
                        using (SqlDataAdapter da = new SqlDataAdapter())
                        {
                            da.SelectCommand = cmd;
                            using (DataSet ds = new DataSet())
                            {
                                da.Fill(ds);
                                con.Close();
                                return ds;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        public static Dictionary<string, dynamic> GetAllUsernameSetCache(string cacheName, int cacheTime = 60)
        {
            Dictionary<string, dynamic> mapUsername= new Dictionary<string, dynamic>();
            if (HttpContext.Current.Cache[cacheName] == null)
            {
                DataSet ds = GetDataSet("_spListAllUsername", null);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataTable dt = ds.Tables[0];
                    foreach (DataRow dr in dt.Rows)
                        mapUsername.Add(dr["cAccName"].ToString().ToLower(), true);
                    HttpContext.Current.Cache.Insert(cacheName, mapUsername, null, DateTime.Now.AddSeconds(cacheTime), TimeSpan.Zero);
                }
            }
            return (Dictionary<string, dynamic>)HttpContext.Current.Cache[cacheName];
        }
        public static void ExecuteSP(string sp, List<SqlParameter> sqlParams)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(sp, con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        if (sqlParams != null)
                        {
                            foreach (IDataParameter para in sqlParams)
                            {
                                cmd.Parameters.Add(para);
                            }
                        }
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}