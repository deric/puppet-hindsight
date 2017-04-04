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
end
