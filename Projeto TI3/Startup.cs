using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Projeto_TI3.Startup))]
namespace Projeto_TI3
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
