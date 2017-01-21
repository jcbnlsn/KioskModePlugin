
Documentation and samplecode for:
###**Kiosk Mode for MacOS - Corona SDK Plugin**

Kiosk mode lets you control the user experience by manipulating numerous system user interface elements from within your application. For example:

* You can decide whether you want users to the see the Dock and menu bar and whether the Apple menu is active.
* You can disable activities that take users out of your application, such as process switching, the Force Quit window, hiding the application, and Exposé
* You can prevent users from restarting or powering down the computer

###**Syntax**
```lua
kioskMode.setPresentation ( options )
```

**options**
A table containing a comma-delimited list of options.

The presentation options can consist of one or more of the following strings:

"Default",                     --Default settings. No special behavior.

"AutoHideDock",                --Dock appears when moused to. Spotlight menu is disabled.

"HideDock",                    --Dock is entirely unavailable. Spotlight menu is disabled.

"AutoHideMenuBar",             --Menu Bar appears when moused to.

"HideMenuBar",                 --Menu Bar is entirely unavailable.

"DisableAppleMenu",            --All Apple menu items are disabled.

"DisableProcessSwitching",     -- Cmd+Tab UI is disabled. All Exposé functionality is also disabled.

"DisableForceQuit",            --Cmd+Opt+Esc panel is disabled.

"DisableSessionTermination",   --PowerKey panel and Restart/Shut Down/Log Out are disabled.

"DisableHideApplication",      -- Application "Hide" menu item is disabled.

"DisableMenuBarTransparency"   --The transparent appearance of the menu bar is disabled.

Not all combinations of options are valid. Read more here:
https://developer.apple.com/library/content/technotes/KioskMode/Introduction/Introduction.html

###**Gotchas**
Kiosk Mode doesn't allow you to disable the quit application shortcut (CMD+Q).

To prevent users from quitting kiosk mode you can reassign the quit command to some obscure shortcut eg. CMD+ALT+SHIFT+B+S
Read how to here: https://www.quora.com/How-do-I-disable-Command-q-in-OS-X

###**Project Settings**
To use this plugin, add an entry into the plugins table of build.settings. When added, the build server will integrate the plugin during the build phase.
```lua
settings =
{
    plugins =
    {
        ["plugin.kioskMode"] = { publisherId = "net.shakebrowser" }
    },      
}
```

###**Example**
```lua
local kiosk = require("plugin.kioskMode")

if "simulator" ~= system.getInfo("environment") then -- Disable in simulator (or simulator will go into kiosk mode)
    kiosk.setPresentation{
        "HideDock",
        "HideMenuBar",
        "DisableForceQuit",
        "DisableHideApplication"
    }
end
```
