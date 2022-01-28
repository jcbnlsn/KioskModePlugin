//
//  PluginKioskMode.h
//
//  Copyright (c) 2016 Jacob Nielsen. All rights reserved.
//  https://developer.apple.com/library/content/technotes/KioskMode/Introduction/Introduction.html

#ifndef _PluginKioskMode_H__
#define _PluginKioskMode_H__

#include "CoronaLua.h"
#include "CoronaMacros.h"

#import <Cocoa/Cocoa.h>

CORONA_EXPORT int luaopen_plugin_kioskMode( lua_State *L );

#endif // _PluginKioskMode_H__
