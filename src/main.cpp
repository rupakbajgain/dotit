#include <sol/sol.hpp>

int main(int argc, char* argv[]) {
  sol::state lua;

  lua.open_libraries();

  const std::string package_path = lua["package"]["path"];
  lua["package"]["path"] = package_path + ";./lua/lib/?.lua;./lua/includes/?.lua";


  if (argc==2){
    std::string option = argv[1];
    if(option=="update"){
      lua.script_file("lua/update.lua");
    }else if(option=="sync"){
      lua.script_file("lua/sync.lua");
    }
    return 0;
  };

  lua.script_file("lua/init.lua");
  lua.script_file("main.lua");
  lua.script_file("lua/finalize.lua");

  return 0;
}
