using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace RegisterUser
{
    public partial class Register : System.Web.UI.Page
    {
        private bool isAvailableUsername(string username)
        {
            bool isUsernameAvailable = true;
            try
            {
                Dictionary<string, dynamic> mapUser = Common.GetAllUsernameSetCache("AllUsername");
                if (mapUser[username] != null)
                    isUsernameAvailable = false;
                return isUsernameAvailable;
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("The given key was not present in the dictionary"))
                    return true;
                else
                    throw ex;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var cmd = Request.Params["cmd"];
                Response.ContentType = "application/json";
                if (cmd != null)
                    switch (cmd)
                    {
                        case "CheckUsername":
                            {
                                bool isUsernameAvailable = true;
                                try {
                                    var txtUserName = Request.Form["txtUserName"].ToString().ToLower();
                                    Dictionary<string, dynamic> mapUser = Common.GetAllUsernameSetCache("AllUsername");
                                    if (mapUser[txtUserName] != null)
                                        isUsernameAvailable = false;
                                    Response.Write(isUsernameAvailable.ToString().ToLower());
                                }
                                catch(Exception ex)
                                {
                                    if(ex.Message.Contains("The given key was not present in the dictionary"))
                                        Response.Write(isUsernameAvailable.ToString().ToLower());
                                    else Response.Write(ex.Message);
                                }
                                break;
                            }
                        case "Register":
                            {
                                var txtCode = Request.Form["txtCode"].ToString();
                                var msg = "";
                                if (txtCode != (String)Session["Captcha"] || txtCode == "")
                                    msg = "{\"success\":false, \"msg\":\"" + "Sai mã bảo mật" + "\"}";
                                else
                                {
                                    string username = Request.Form["txtUserName"].ToString();
                                    string password = Request.Form["txtPassword"].ToString();
                                    try
                                    {
                                        if (isAvailableUsername(username))
                                        {
                                            Common.ExecuteSP("_spCreateUser", new List<SqlParameter> {
                                                new SqlParameter("@username", SqlDbType.VarChar, 12) { Value = username },
                                                new SqlParameter("@password", SqlDbType.VarChar, 50) { Value = password }
                                            });
                                            ((Dictionary<string, dynamic>)HttpContext.Current.Cache["AllUsername"]).Add(username, true);
                                            msg = "{\"success\":true}";
                                        }
                                        else msg = "{\"success\":false, \"msg\":\" + \"username đã được đăng kí trước\" + \"}";

                                    }
                                    catch (Exception ex)
                                    {
                                        var exS = ex.Message.ToString();
                                        msg = "{\"success\":false, \"msg\":\"" + ex.Message.ToString() + "\"}";
                                    }
                                }
                                Response.Write(msg);
                                break;
                            }
                        case "GetCode":
                            {
                                Response.Write(Session["Captcha"].ToString());
                                break;
                            }
                    }
            }
            catch (Exception ex)
            {
                Response.Write(ex.ToString());
            }
        }
    }
}