# vim module #

[![Build Status](
https://api.travis-ci.org/ghoneycutt/puppet-module-vim.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-vim)

This module manages vim and the root .vimrc file and .vim directory.

===

# Compatibility #

Puppet Versions | < 2.6 | 2.6 | 2.7 | 3.x |
:---------------|:-----:|:---:|:---:|:----:
**ruby 1.8.7**  | no    | no  | **yes** | **yes**
**ruby 1.9.3**  | no    | no  | **yes** | **yes**

## OS Distributions ##

This module has been tested to work on the following systems. For other systems, you will need to specify the vim packages.

* EL 5
* EL 6
* SLES 11

===

# Parameters #

package_list
------------
The packages to install.

- *Default*: USE_DEFAULTS

root_vimrc_source
-----------------
Path to .vimrc on master in the form of [module]/[filename]

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
Path to .vim/ on master in the form of [module]/[filename]

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

===
# Hiera keys with all module defaults:
<pre>
vim::package_list: 'USE_DEFAULTS'
vim::root_vimrc_source: 'vim/vimrc'
vim::root_vimrc_path: "${::root_home}/.vimrc"
vim::root_vimrc_owner: 'root'
vim::root_vimrc_group: 'root'
vim::root_vimrc_mode: '0644'
vim::root_vim_dir_source: 'vim/vim'
vim::root_vim_dir_path: "${::root_home}/.vim"
vim::root_vim_dir_owner: 'root'
vim::root_vim_dir_group: 'root'
vim::root_vim_dir_mode: '0644'
</pre>
