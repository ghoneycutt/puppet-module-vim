# vim

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with vim](#setup)
   * [What vim affects](#what-vim-affects)
   * [Beginning with vim](#beginning-with-vim)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This is a very simple module to manage Vim. It manages the packages, the
`.vimrc` configuration file and populates a few syntax files for Puppet.
This is meant to make vim useful on servers with some basic, sane
settings. It is not meant to manage a developer's workstation where you
would be managing a ton of plugins and configuration.

Documented with Puppet Strings at
[http://ghoneycutt.github.io/puppet-module-vim/](http://ghoneycutt.github.io/puppet-module-vim/).

## Setup

### What vim affects

This module manages the `/root/.vimrc` file and `/root/.vim` directory,
which gets some plugins installed. It also manages the related vim
packages for the platform.

### Beginning with vim

Declare the `vim` class.

## Usage

The normal use case.

```puppet
include vim
```

To specify the package list.

```puppet
class { 'vim':
  package_list => ['vim', 'vim-whatever'],
}
```

## Limitations

This module officially supports the platforms listed in the
`metadata.json`. It does not fail on unsupported platforms and has been
known to work on many, many platforms since its creation in 2010.

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

See [LICENSE](LICENSE) file.
