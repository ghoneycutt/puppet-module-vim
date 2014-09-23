require 'spec_helper'
describe 'vim' do

  platforms = {
    'debian6' =>
      { :osfamily => 'Debian',
        :release  => '6',
        :packages => [ 'vim-common', 'vim-nox', 'vim-runtime'],
      },
    'el5' =>
      { :osfamily => 'RedHat',
        :release  => '5',
        :packages => [ 'vim-common', 'vim-enhanced', 'vim-minimal'],
      },
    'el6' =>
      { :osfamily => 'RedHat',
        :release  => '6',
        :packages => [ 'vim-common', 'vim-enhanced', 'vim-minimal'],
      },
    'suse10' =>
      { :osfamily => 'Suse',
        :release  => '10',
        :packages => 'vim',
      },
    'suse11' =>
      { :osfamily => 'Suse',
        :release  => '11',
        :packages => ['vim','vim-base','vim-data'],
      },
    'suse12' =>
      { :osfamily => 'Suse',
        :release  => '12',
        :packages => ['vim','vim-base','vim-data'],
      },
    'solaris10' =>
      { :osfamily => 'Solaris',
        :release  => '5.10',
        :packages => ['CSWvim'],
      },
    'solaris11' =>
      { :osfamily => 'Solaris',
        :release  => '5.11',
        :packages => ['vim'],
      },
  }

  describe 'with default values for parameters on' do
    platforms.sort.each do |k,v|
      context "#{v[:osfamily]} #{v[:release]}" do
        if v[:osfamily] == 'Solaris'
          let :facts do
            { :osfamily      => v[:osfamily],
              :kernelrelease => v[:release],
            }
          end
        else
          let :facts do
            { :osfamily          => v[:osfamily],
              :lsbmajdistrelease => v[:release],
            }
          end
        end

        it { should compile.with_all_deps }

        it { should contain_class('vim')}

        if v[:packages].class == Array
          v[:packages].each do |pkg|
            it {
              should contain_package(pkg).with({
                'ensure' => 'present',
              })
            }
          end
        else
          it {
            should contain_package(v[:packages]).with({
              'ensure' => 'present',
            })
          }
        end

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

  describe 'with package_list set' do
    context 'to an array' do
      let(:params) { { :package_list => ['vimfoo','vimbar'] } }
      let :facts do
        { :osfamily          => 'RedHat',
          :lsbmajdistrelease => '6',
        }
      end

      it { should compile.with_all_deps }

      it { should contain_class('vim')}

      it {
        should contain_package('vimfoo').with({
          'ensure' => 'present',
        })
      }

      it {
        should contain_package('vimbar').with({
          'ensure' => 'present',
        })
      }
    end

    context 'to a string' do
      let(:params) { { :package_list => 'string' } }
      let :facts do
        { :osfamily          => 'RedHat',
          :lsbmajdistrelease => '6',
        }
      end

      it { should compile.with_all_deps }

      it { should contain_class('vim')}

      it {
        should contain_package('string').with({
          'ensure' => 'present',
        })
      }
    end

    context 'an invalid type (boolean)' do
      let(:params) { { :package_list => true } }
      let :facts do
        { :osfamily          => 'RedHat',
          :lsbmajdistrelease => '6',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('vim')
        }.to raise_error(Puppet::Error,/vim::package_list must be a string or an array./)
      end
    end
  end

  describe 'with unsupported' do
    context 'version of Suse' do
      let :facts do
        { :osfamily          => 'Suse',
          :lsbmajdistrelease => '9',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('vim')
        }.to raise_error(Puppet::Error,/^vim supports Suse 10, 11, and 12. Detected lsbmajdistrelease is <9>/)
      end
    end

    context 'version of Solaris' do
      let :facts do
        { :osfamily      => 'Solaris',
          :kernelrelease => '5.9',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('vim')
        }.to raise_error(Puppet::Error,/^vim supports Solaris 10 and 11. Detected kernelrelease is <5.9>/)
      end
    end

    context 'osfamily' do
      let :facts do
        { :osfamily          => 'Unsupported',
          :lsbmajdistrelease => '9',
        }
      end

      it 'should fail' do
        expect {
          should contain_class('vim')
        }.to raise_error(Puppet::Error,/^vim supports OS families Debian, RedHat, Suse and Solaris. Detected osfamily is <Unsupported>./)
      end
    end
  end
end
