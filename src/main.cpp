#include <sol/sol.hpp>

int main(int argc, char* argv[]) {
  sol::state lua;

  lua.open_libraries();

  const std::string package_path = lua["package"]["path"];
  lua["package"]["path"] = package_path + ";./lua/lib/?.lua";

  lua.script_file("lua/init.lua");
  lua.script_file("main.lua");

  return 0;
}
