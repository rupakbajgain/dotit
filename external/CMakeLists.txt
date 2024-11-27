### lua
add_library(lua
  lua/src/lapi.c
  lua/src/lauxlib.c
  lua/src/lbaselib.c
  lua/src/lcode.c
  lua/src/lcorolib.c
  lua/src/lctype.c
  lua/src/ldblib.c
  lua/src/ldebug.c
  lua/src/ldo.c
  lua/src/ldump.c
  lua/src/lfunc.c
  lua/src/lgc.c
  lua/src/linit.c
  lua/src/liolib.c
  lua/src/llex.c
  lua/src/lmathlib.c
  lua/src/lmem.c
  lua/src/loadlib.c
  lua/src/lobject.c
  lua/src/lopcodes.c
  lua/src/loslib.c
  lua/src/lparser.c
  lua/src/lstate.c
  lua/src/lstring.c
  lua/src/lstrlib.c
  lua/src/ltable.c
  lua/src/ltablib.c
  #lua/src/ltests.c
  lua/src/ltm.c
  lua/src/lua.c
  lua/src/lundump.c
  lua/src/lutf8lib.c
  lua/src/lvm.c
  lua/src/lzio.c
)
add_library(lua::lua ALIAS lua)

if (WIN32)
  target_compile_definitions(lua PRIVATE LUA_USE_WINDOWS)
endif()

target_include_directories(lua PUBLIC lua)
if (UNIX)
  target_compile_definitions(lua PRIVATE LUA_USE_LINUX)
  target_link_libraries(lua PRIVATE dl)
endif()

### sol2
set(SOL2_LUA_VERSION "5.4.4" CACHE STRING "The version of Lua used")
# we build Lua manually
set(SOL2_BUILD_LUA FALSE CACHE BOOL "Always build Lua, do not search for it in the system")

add_library(sol2 INTERFACE)
target_include_directories(sol2 INTERFACE ./sol2)
add_library(sol2::sol2 ALIAS sol2)
