local class = require 'middleclass'

local Managers = class('Managers') -- 'Fruit' is the class' name

-- todo: sync and upgrade later
function Managers:initialize(name,add_s,remove_s,sup_many)
  self.name = name
  self.add_s = add_s
  self.remove_s = remove_s
  self.sup_many = sup_many
end

function Managers:individual_op(prog,command)
    os.execute(command .. ' ' .. prog)
end

function Managers:block_op(progs,command)
    -- if sup many supply block else
    if(self.sup_many) then
        prog_str = table.concat(progs, " ") -->
        os.execute(command .. ' ' .. prog_str)
    else
        for _,i in pairs(progs) do
            self:individual_op(i,command)
        end
    end
end


function Managers:add_progs(prog)
    if #prog ~= 0 then
        self:block_op(prog,self.add_s)
    end
end

function Managers:remove_progs(prog)
    if #prog ~= 0 then
        self:block_op(prog,self.remove_s)
    end
end

--local pacman = Managers:new('pacman','pacman -s','pacman -r',true)
--pacman:add_prog({'a','b','c'})

return Managers
