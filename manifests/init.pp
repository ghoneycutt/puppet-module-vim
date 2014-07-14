# == Class: vim
#
# This module manages vim
#
class vim (
  $package_list        = 'USE_DEFAULTS',

  $root_vimrc_source   = 'vim/vimrc',
  $root_vimrc_path     = "${::root_home}/.vimrc",
  $root_vimrc_owner    = 'root',
  $root_vimrc_group    = 'root',
  $root_vimrc_mode     = '0644',

  $root_vim_dir_source = 'vim/vim',
  $root_vim_dir_path   = "${::root_home}/.vim",
  $root_vim_dir_owner  = 'root',
  $root_vim_dir_group  = 'root',
  $root_vim_dir_mode   = '0644',
) {

  case $::osfamily {
    'Debian': {
      $default_package_list = [
        'vim-common',
        'vim-nox',
        'vim-runtime',
      ]
    }
    'RedHat': {
      $default_package_list = [
        'vim-common',
        'vim-enhanced',
        'vim-minimal',
      ]
    }
    'Suse': {
      case $::lsbmajdistrelease {
        '10': {
          $default_package_list = 'vim'
        }
        '11', '12': {
          $default_package_list = [
            'vim',
            'vim-base',
            'vim-data',
          ]
        }
        default: {
          fail("vim supports Suse 10, 11, and 12. Detected lsbmajdistrelease is <${::lsbmajdistrelease}>.")
        }
      }
    }
    default: {
      fail("vim supports OS families Debian, RedHat, and Suse. Detected osfamily is <${::osfamily}>.")
    }
  }

  if $package_list == 'USE_DEFAULTS' {
    $package_list_real = $default_package_list
  } else {
    $package_list_real = $package_list
  }
  if type($package_list_real) != 'String' and type($package_list_real) != 'Array' {
    fail('vim::package_list must be a string or an array.')
  }

  package { $package_list_real:
    ensure => present,
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
