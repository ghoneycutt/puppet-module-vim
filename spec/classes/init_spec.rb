require 'spec_helper'
describe 'vim' do

  describe 'class vim' do

    context 'default options on osfamily Debian' do
      let :facts do
        { :osfamily => 'Debian' }
      end

      it { should include_class('vim')}

      it {
        should contain_package('vim_packages').with({
          'name'   => ['vim-common','vim-nox','vim-runtime'],
          'ensure' => 'present',
        })
      }

      it {
        should contain_file('root_vimrc').with({
          'ensure' => 'file',
          'path'   => '/.vimrc',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      }

      it {
        should contain_file('root_vim_dir').with({
          'ensure' => 'directory',
          'path'   => '/.vim',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      }
    end
    context 'default options on osfamily RedHat' do
      let :facts do
        { :osfamily => 'RedHat' }
      end

      it { should include_class('vim')}

      it {
        should contain_package('vim_packages').with({
          'name'   => ['vim-common','vim-enhanced','vim-minimal'],
          'ensure' => 'present',
        })
      }

      it {
        should contain_file('root_vimrc').with({
          'ensure' => 'file',
          'path'   => '/.vimrc',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      }

      it {
        should contain_file('root_vim_dir').with({
          'ensure' => 'directory',
          'path'   => '/.vim',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      }
    end

    context 'default options on osfamily Suse' do
      let :facts do
        { :osfamily => 'Suse' }
      end

      it { should include_class('vim')}

      it {
        should contain_package('vim_packages').with({
          'name'   => ['vim','vim-base','vim-data'],
          'ensure' => 'present',
        })
      }

      it {
        should contain_file('root_vimrc').with({
          'ensure' => 'file',
          'path'   => '/.vimrc',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      }

      it {
        should contain_file('root_vim_dir').with({
          'ensure' => 'directory',
          'path'   => '/.vim',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      }
    end
  end
end
