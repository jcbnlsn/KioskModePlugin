//
//  PluginKioskMode.mm
//
//  Copyright (c) 2016 Jacob Nielsen. All rights reserved.
//

#import "PluginKioskMode.h"
#include "CoronaRuntime.h"

// ----------------------------------------------------------------------------

class PluginKioskMode
{
public:
    typedef PluginKioskMode Self;
    
public:
    static const char kName[];
    static const char kEvent[];
    
protected:
    PluginKioskMode();
    
public:
    bool Initialize( CoronaLuaRef listener );
    
public:
    CoronaLuaRef GetListener() const { return fListener; }
    
public:
    static int Open( lua_State *L );
    
protected:
    static int Finalizer( lua_State *L );
    
public:
    static Self *ToLibrary( lua_State *L );
    
public:
    static int setPresentation( lua_State *L );
    
private:
    CoronaLuaRef fListener;
};

// ----------------------------------------------------------------------------

// This corresponds to the name of the library, e.g. [Lua] require "plugin.library"
const char PluginKioskMode::kName[] = "plugin.KioskMode";

// This corresponds to the event name, e.g. [Lua] event.name
const char PluginKioskMode::kEvent[] = "KioskMode";

PluginKioskMode::PluginKioskMode()
:	fListener( NULL )
{
}

bool
PluginKioskMode::Initialize( CoronaLuaRef listener )
{
    // Can only initialize listener once
    bool result = ( NULL == fListener );
    
    if ( result )
    {
        fListener = listener;
    }
    
    return result;
}

int
PluginKioskMode::Open( lua_State *L )
{
    // Register __gc callback
    const char kMetatableName[] = __FILE__; // Globally unique string to prevent collision
    CoronaLuaInitializeGCMetatable( L, kMetatableName, Finalizer );
    
    // Functions in library
    const luaL_Reg kVTable[] =
    {
        { "setPresentation", setPresentation },
        
        { NULL, NULL }
    };
    
    // Set library as upvalue for each library function
    Self *library = new Self;
    CoronaLuaPushUserdata( L, library, kMetatableName );
    
    luaL_openlib( L, kName, kVTable, 1 ); // leave "library" on top of stack
    
    return 1;
}

int
PluginKioskMode::Finalizer( lua_State *L )
{
    Self *library = (Self *)CoronaLuaToUserdata( L, 1 );
    
    CoronaLuaDeleteRef( L, library->GetListener() );
    
    delete library;
    
    return 0;
}

PluginKioskMode *
PluginKioskMode::ToLibrary( lua_State *L )
{
    // library is pushed as part of the closure
    Self *library = (Self *)CoronaLuaToUserdata( L, lua_upvalueindex( 1 ) );
    return library;
}

// [Lua] kioskMode.setPresentation( options )
int
PluginKioskMode::setPresentation( lua_State *L )
{
    // Options enum
    NSApplicationPresentationOptions options = 0;

    // If the user has passed in a table
	if ( lua_istable( L, 1 ) )
	{
	
		// Get the number of defined options from lua
		int numOfTypes = luaL_getn( L, 1 );

		// Loop through the options array
		for ( int i = 1; i <= numOfTypes; i++ )
		{
			// Get the tables first value
			lua_rawgeti( L, -1, i );
			
			// Enforce string type
			luaL_checktype( L, -1, LUA_TSTRING );
	
			// The current type
			const char *currentType = lua_tostring( L, -1 );
			
			if ( 0 == strcmp( "Default", currentType ) )
			{
				options += NSApplicationPresentationDefault;
			}
            else if ( 0 == strcmp( "AutoHideDock", currentType ) )
			{
				options += NSApplicationPresentationAutoHideDock;
			}
            else if ( 0 == strcmp( "HideDock", currentType ) )
			{
				options += NSApplicationPresentationHideDock;
			}
            else if ( 0 == strcmp( "AutoHideMenuBar", currentType ) )
			{
				options += NSApplicationPresentationAutoHideMenuBar;
			}
            else if ( 0 == strcmp( "HideMenuBar", currentType ) )
			{
				options += NSApplicationPresentationHideMenuBar;
			}
            else if ( 0 == strcmp( "DisableAppleMenu", currentType ) )
			{
				options += NSApplicationPresentationDisableAppleMenu;
			}
            else if ( 0 == strcmp( "DisableProcessSwitching", currentType ) )
			{
				options += NSApplicationPresentationDisableProcessSwitching;
			}
            else if ( 0 == strcmp( "DisableForceQuit", currentType ) )
			{
				options += NSApplicationPresentationDisableForceQuit;
			}
            else if ( 0 == strcmp( "DisableSessionTermination", currentType ) )
			{
				options += NSApplicationPresentationDisableSessionTermination;
			}
            else if ( 0 == strcmp( "DisableHideApplication", currentType ) )
			{
				options += NSApplicationPresentationDisableHideApplication;
			}
            else if ( 0 == strcmp( "DisableMenuBarTransparency", currentType ) )
			{
				options += NSApplicationPresentationDisableMenuBarTransparency;
			}
            else
            {
                luaL_error( L, "KioskMode Error. You passed an invalid options key: %s", currentType );
            }
			
			// Pop the current filter
			lua_pop( L, 1 );
		}
	}
	// If the user passed nil
	if ( lua_isnil( L, 1 ) )
	{
		// Log warning
        luaL_error( L, "KioskMode Error. You need to pass an options table." );
	}
    
    // If no options passed
    if ( options == 0 )
    {
        luaL_error( L, "KioskMode Error. You need to pass an options table." );
    }

    @try {
        [NSApp setPresentationOptions:options];
    }
    @catch(NSException * exception) {
        luaL_error( L, "KioskMode Error.  Make sure you pass a valid combination of options." );
    }
    
    return 0;
}

// ----------------------------------------------------------------------------

CORONA_EXPORT int luaopen_plugin_kioskMode( lua_State *L )
{
    return PluginKioskMode::Open( L );
}
