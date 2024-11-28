add_executable(dotit main.cpp)

target_link_libraries(dotit PRIVATE
  lua::lua
  sol2::sol2
)
set_property(TARGET dotit PROPERTY CXX_STANDARD 17)
