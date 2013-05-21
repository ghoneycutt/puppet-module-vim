# vim module #

This module manages vim and the root .vimrc file and .vim directory.

# Compatibility #

This module has been tested to work on the following systems.

* Should work on any system that can use the package resource.

# Parameters #

package_list
------------
The packages to install.

- *Default*: vim-common, vim-enhanced, vim-minimal

root_vimrc_source
-----------------
Where the root .vimrc to install is located (on the master)

- *Default*: vim/vimrc

root_vimrc_path
---------------
Where to install the root .vimrc file.

- *Default*: ${::root_home}/.vimrc

root_vimrc_owner
----------------
The .vimrc owner.

- *Default*: root

root_vimrc_group
----------------
The .vimrc group.

- *Default*: root

root_vimrc_mode
---------------
The .vimrc mode.

- *Default*: 0644

root_vim_dir_source
-------------------
Where the root .vim directory to install is located (on the master).

- *Default*: vim/vim

root_vim_dir_path
-----------------
Where to install the root .vim directory.

- *Default*: ${::root_home}/.vim

root_vim_dir_owner
------------------
The .vim directory owner.

- *Default*: root

root_vim_dir_mode
-----------------
The .vim directory mode.

- *Default*: 0644
