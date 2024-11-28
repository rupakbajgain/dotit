-- Defining System Packages
table.insert(packages.pacman, "firefox")
table.insert(packages.pacman, "cmake")
table.insert(packages.pacman, "git")
table.insert(packages.pacman, {name="flatpak",post_install_hook=function()
  os.execute("flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || exit 1")
end})
table.insert(packages.pacman, {name="rustup",post_install_hook=function()
  os.execute("rustup default stable || exit 1")
end})

--install paru (todo: fixit)
services.paru = {enable = true}

--paru
table.insert(packages.paru, "fastfetch")
table.insert(packages.paru, "less")
table.insert(packages.paru, "discord-canary")

--flatpak
table.insert(packages.flatpak, "com.github.tchx84.Flatseal")
table.insert(packages.flatpak, "net.lutris.Lutris")
