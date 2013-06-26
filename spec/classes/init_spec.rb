require 'spec_helper'
describe 'vim' do

  describe 'class vim' do

    context 'default options for EL' do
      let :facts do 
        {
          :osfamily => 'RedHat',
          :lsbmajdistrelease => '5',
        }
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
#        should contain_file('ntp_conf').with_content(/server 0.us.pool.ntp.org\nserver 1.us.pool.ntp.org\nserver 2.us.pool.ntp.org/)
      }

      it {
        should contain_file('root_vim_dir').with({
          'ensure' => 'directory',
          'path'   => '/.vim',
          'owner'  => 'root',
          'mode'   => '0644',
        })
      }

    end

    context 'on unsupported platform, Debian, should fail' do
      let(:facts) { {:osfamily => 'debian' } }
      it do
        expect {
          should include_class('vim')
        }.to raise_error(Puppet::Error,/vim module only supports osfamily 'RedHat' and debian was detected./)
      end
    end
  end
end
