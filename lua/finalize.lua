local inspect = require "inspect"

-- Find the length of a file
--   filename: file name
-- returns
--   len: length of file
--   asserts on error
function length_of_file(filename)
  local fh = assert(io.open(filename, "rb"))
  local len = assert(fh:seek("end"))
  fh:close()
  return len
end

-- Return true if file exists and is readable.
function file_exists(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

-- Guarded seek.
-- Same as file:seek except throws string
-- on error.
-- Requires Lua 5.1.
function seek(fh, ...)
  assert(fh:seek(...))
end

-- Read an entire file.
-- Use "a" in Lua 5.3; "*a" in Lua 5.1 and 5.2
function readall(filename)
  local fh = assert(io.open(filename, "rb"))
  local contents = assert(fh:read(_VERSION <= "Lua 5.2" and "*a" or "a"))
  fh:close()
  return contents
end

-- Write a string to a file.
function write(filename, contents)
  local fh = assert(io.open(filename, "wb"))
  fh:write(contents)
  fh:flush()
  fh:close()
end

-- Read, process file contents, write.
function modify(filename, modify_func)
  local contents = readall(filename)
  contents = modify_func(contents)
  write(filename, contents)
end

--
-----------------------------
--
-- my funcs
function subtract(table1, table2)
    local r = {}
    for k,i in pairs(table1) do
        for _,j in pairs(table2) do
            if i == j then
                goto continue
            end
        end
        table.insert(r,i)
        ::continue::
    end
    return r
end

function diff(table1, tab2)
    local table2 = {}
    for _,i in pairs(tab2) do
        if type(i) == "string" then
            table.insert(table2, i)
        else
            --print(i)
            table.insert(table2, i.name)
        end
    end
    return {rem_prog=subtract(table1,table2),add_prog=subtract(table2,table1)}
end

function compact(tab2)
    local table2 = { }
    for _,i in pairs(tab2) do
        if type(i) == "string" then
            table.insert(table2, i)
        else
            table.insert(table2, i.name)
        end
    end
    return table2
end

function execute_hooks(fulltable,deltable,op)
    for _,i in pairs(fulltable) do
        if type(i) ~= "table" then goto continue end
        for __,j in pairs(deltable) do
            --print(i.name,j)
            if i.name == j then
                if i[op] ~= nil then
                    i[op]()
                end
            end
        end
        ::continue::
    end
end

--
-----------------------------
--
local luajson = require "lunajson"

local file = "./state/current"
local contents = {}
if file_exists(file) then
    local text = readall(file)
    contents = luajson.decode(text)
end
--

local changes_made = false
--
if contents.pacman == nil then contents.pacman = { } end
local d = diff(contents.pacman, packages.pacman)
execute_hooks(packages.pacman,d.add_prog,'pre_install_hook')
managers.pacman:add_progs(d.add_prog)
execute_hooks(packages.pacman,d.add_prog,'post_install_hook')
execute_hooks(packages.pacman,d.add_prog,'pre_remove_hook')
managers.pacman:remove_progs(d.rem_prog)
execute_hooks(packages.pacman,d.add_prog,'post_remove_hook')
if #d.add_prog>0 or #d.rem_prog>0 then changes_made = true end
local new_pacman_list = compact(packages.pacman)
--print(inspect(new_pacman_list))

--this is todo, always install
if contents.paru_from_github==nil and services.paru.enable==true then
    os.execute("sudo pacman -S --needed base-devel")
    os.execute("git clone https://aur.archlinux.org/paru.git state/paru")
    os.execute("makepkg -si -D state/paru")
    changes_made = true
end
--
if contents.paru == nil then contents.paru = { } end
local d = diff(contents.paru, packages.paru)
execute_hooks(packages.paru,d.add_prog,'pre_install_hook')
managers.paru:add_progs(d.add_prog)
execute_hooks(packages.paru,d.add_prog,'post_install_hook')
execute_hooks(packages.paru,d.add_prog,'pre_remove_hook')
managers.paru:remove_progs(d.rem_prog)
execute_hooks(packages.paru,d.add_prog,'post_remove_hook')
if #d.add_prog>0 or #d.rem_prog>0 then changes_made = true end
local new_paru_list = compact(packages.paru)
--
if contents.flatpak == nil then contents.flatpak = { } end
local d = diff(contents.flatpak, packages.flatpak)
execute_hooks(packages.flatpak,d.add_prog,'pre_install_hook')
managers.flatpak:add_progs(d.add_prog)
execute_hooks(packages.flatpak,d.add_prog,'post_install_hook')
execute_hooks(packages.flatpak,d.add_prog,'pre_remove_hook')
managers.flatpak:remove_progs(d.rem_prog)
execute_hooks(packages.flatpak,d.add_prog,'post_remove_hook')
if #d.add_prog>0 or #d.rem_prog>0 then changes_made = true end
local new_flatpak_list = compact(packages.flatpak)
--
if changes_made then
local new_json = {pacman=new_pacman_list,paru_from_github={"paru"},paru=new_paru_list,flatpak=new_flatpak_list}
write(file,luajson.encode(new_json))
else
print "Nothing to do.."
end
