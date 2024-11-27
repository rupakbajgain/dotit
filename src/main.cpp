#include <sol/sol.hpp>

int main(int argc, char* argv[]) {
  sol::state lua;

  lua.open_libraries();

  lua.script_file("lua/init.lua");
  lua.script_file("main.lua");

  return 0;
}
