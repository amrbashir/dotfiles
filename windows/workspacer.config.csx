#r "C:\Program Files\workspacer\workspacer.Shared.dll"
#r "C:\Program Files\workspacer\plugins\workspacer.Bar\workspacer.Bar.dll"

using System;
using workspacer;
using workspacer.Bar;
using workspacer.Bar.Widgets;

Action<IConfigContext> doConfig = (context) =>
{
    context.Branch = Branch.Unstable;

    context.AddBar(new BarPluginConfig() {
        FontSize = 10,
        FontName = "Segoe UI Variable",
        BarHeight = 20,
        DefaultWidgetBackground = new Color(0,0,0),
        RightWidgets = () => new IBarWidget[] {}
    });

    context.WorkspaceContainer.CreateWorkspaces("1", "2", "3", "4", "5");

    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("ueli.exe"));
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("SearchHost.exe"));
    context.WindowRouter.AddFilter((window) => !window.ProcessFileName.Equals("StartMenuExperienceHost.exe"));
    context.WindowRouter.AddFilter((window) => !window.Class.Equals("#32770"));

    context.Keybinds.Unsubscribe(KeyModifiers.Alt, Keys.Space);
};

return doConfig;



