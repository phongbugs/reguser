using System;
namespace RegisterUser
{
    public partial class Default : System.Web.UI.Page
    {
        protected bool isTestMode = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["iTest"] !=null)
                isTestMode = true;
        }
    }
}