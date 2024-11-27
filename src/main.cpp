#include <sol/sol.hpp>

int main(int argc, char* argv[]) {
  sol::state lua;

  lua.open_libraries(sol::lib::base);

  lua.script_file("main.lua");

  return 0;
}
