----------------------------------------------------------------------
--
--  KioskMode for MacOS - Corona SDK Plugin Sample Project.
--  Created by Jacob Nielsen on 20/01/2017.
--  (c) 2017
--
----------------------------------------------------------------------

--[[ 
    -- Pass one or more of the following options.
    -- The plugin interfaces Apples Kiosk Mode API. Not all combinations of options are valid. Read more here:
    -- https://developer.apple.com/library/content/technotes/KioskMode/Introduction/Introduction.html
    
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
--]]

-- Example
local kiosk = require("plugin.kioskMode")

if "simulator" ~= system.getInfo("environment") then -- Disable in simulator (or simulator will go into kiosk mode)
    kiosk.setPresentation{
        "HideDock",
        "HideMenuBar",
        "DisableForceQuit",
        "DisableHideApplication"
    }
end

-- Note: If necessary you can disable kiosk mode later on with:
-- kiosk.setPresentation{"Default"}

