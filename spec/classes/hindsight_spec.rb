require 'spec_helper'

describe 'hindsight' do
  context 'default installation' do
    on_supported_os.first do |os, facts|
      let(:facts) do
        facts
      end

      context "hindsight class without any parameters" do
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('hindsight::params') }
        it { is_expected.to contain_class('hindsight::install').that_comes_before('hindsight::config') }
        it { is_expected.to contain_class('hindsight::config') }
        it { is_expected.to contain_class('hindsight::service').that_subscribes_to('hindsight::config') }

        it { is_expected.to contain_service('hindsight') }
        it { is_expected.to contain_package('hindsight').with_ensure('present') }

        it { is_expected.to contain_file('/etc/hindsight').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'hindsight class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('hindsight') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end

  context 'hindsight service' do
    let(:facts) do
      {
        :osfamily        => 'Debian',
        :operatingsystem => 'Debian',
        :lsbdistcodename => 'jessie',
      }
    end
    describe 'allow passing pre-start commands' do
      let(:params) do
        {
          :service_prestart => ['/bin/echo foo'],
        }
      end

      it do
        is_expected.to contain_file('/lib/systemd/system/hindsight.service').with({
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      }).with_content(/ExecStartPre=-\/bin\/echo foo/)
      end

    end
  end

  context 'paths to libraries' do
    let(:facts) do
      {
        :osfamily        => 'Debian',
        :operatingsystem => 'Debian',
        :lsbdistcodename => 'jessie',
      }
    end

    it do
      is_expected.to contain_file('/etc/hindsight/hindsight.cfg').with({
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
    }).with_content(/analysis_threads(\s+)=(\s+)1/)
    end

    it do
      is_expected.to contain_file('/etc/hindsight/hindsight.cfg')
        .with_content(/analysis_lua_path(\s+)=(\s+)"\/usr\/lib\/luasandbox\/modules\/\?.lua/)
    end
  end
end
