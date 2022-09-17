# @summary This module manages Vim
#
# @example
#   include vim
#
# @param package_provider
#   The puppet provider to be used for the package resources.
#
# @param package_list
#   List of vim packages to be present.
#
# @param root_vimrc_source
#   Value of the source parameter used in the file resource for managing
#   `.vimrc`.
#
# @param root_vimrc_path
#   Path to the `.vimrc` configuration file.
#
# @param root_vimrc_owner
#   Owner of the `.vimrc` file.
#
# @param root_vimrc_group
#   Group of the `.vimrc` file.
#
# @param root_vimrc_mode
#   Mode of the `.vimrc` file.
#
# @param root_vim_dir_source
#   Value of the source parameter used in the file resource for managing the
#   `.vim` directory.
#
# @param root_vim_dir_path
#   Path to the `.vim` directory.
#
# @param root_vim_dir_owner
#   Owner of the `.vim` directory.
#
# @param root_vim_dir_group
#   Group of the `.vim` directory.
#
# @param root_vim_dir_mode
#   Mode of the `.vim` directory.
#
class vim (
  Optional[String[1]] $package_provider = undef,
  Array[String[1]] $package_list = ['vim-common', 'vim-enhanced'],

  String[1] $root_vimrc_source = 'vim/vimrc',
  Stdlib::Absolutepath $root_vimrc_path = '/root/.vimrc',
  String[1] $root_vimrc_owner = 'root',
  String[1] $root_vimrc_group = 'root',
  Stdlib::Filemode $root_vimrc_mode = '0644',

  String[1] $root_vim_dir_source = 'vim/vim',
  Stdlib::Absolutepath $root_vim_dir_path = '/root/.vim',
  String[1] $root_vim_dir_owner = 'root',
  String[1] $root_vim_dir_group = 'root',
  Stdlib::Filemode $root_vim_dir_mode = '0644',
) {

  package { $package_list:
    ensure   => present,
    provider => $package_provider,
  }

  file { 'root_vimrc':
    ensure => file,
    source => "puppet:///modules/${root_vimrc_source}",
    path   => $root_vimrc_path,
    owner  => $root_vimrc_owner,
    group  => $root_vimrc_group,
    mode   => $root_vimrc_mode,
  }

  file { 'root_vim_dir':
    ensure  => directory,
    recurse => true,
    source  => "puppet:///modules/${root_vim_dir_source}",
    path    => $root_vim_dir_path,
    owner   => $root_vim_dir_owner,
    group   => $root_vim_dir_group,
    mode    => $root_vim_dir_mode,
  }
}
