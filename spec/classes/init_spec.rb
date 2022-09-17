require 'spec_helper'
describe 'vim' do
  on_supported_os.each do |os, os_facts|
    context "on #{os} with default values for class parameters" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('vim') }

      packages = case os_facts[:os]['family']
                 when 'Debian'
                   ['vim-common', 'vim-nox', 'vim-runtime']
                 when 'RedHat'
                   ['vim-common', 'vim-enhanced']
                 else
                   []
                 end

      packages.each do |pkg|
        it {
          is_expected.to contain_package(pkg).with({
            'ensure'   => 'present',
            'provider' => nil,
          })
        }
      end

      it {
        is_expected.to contain_file('root_vimrc').with({
          'ensure' => 'file',
          'path'   => '/root/.vimrc',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      }

      it {
        is_expected.to contain_file('root_vim_dir').with({
          'ensure' => 'directory',
          'path'   => '/root/.vim',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        })
      }
    end
  end

  describe 'on unsupported platform' do
    let :facts do
      { :os['family'] => 'unsupported' }
    end

    it 'does not fail' do
      expect do
        is_expected.to contain_class('vim')
      end
    end
  end
end
