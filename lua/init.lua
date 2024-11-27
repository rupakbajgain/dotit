packages = {}
managers = {}

--services = {}
--services.paru = {}
--services.paru.enable = false
--
local Managers = require 'managers'
managers.order_begin = {'pacman','system'}
managers.order_mid = {}
managers.order_end = {'services'}
--
managers.pacman = Managers('pacman','sudo pacman -S','sudo pacman -Rns',true)
packages.pacman = {}
-- paru -Syy --sync
-- paru -Syu --upgrade
managers.paru = Managers('paru','paru -S','paru -Rns',true)
packages.paru = {}
--
-- flatpak upgrade
managers.flatpak = Managers('flatpak','flatpak install','flatpak uninstall',true)
packages.flatpak = {}
-- todo: fix-this
-- just custom loader, rememeber this exists
-- later maybe move to git manager, for autoupdates
managers.paru_from_github = true
packages.paru_from_github = {'paru'}
