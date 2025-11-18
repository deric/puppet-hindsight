# frozen_string_literal: true

require 'spec_helper'

describe 'hindsight' do
  _, os_facts = on_supported_os.first

  let(:facts) { os_facts }

  context 'hindsight class without any parameters' do
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('hindsight::params') }
    it { is_expected.to contain_class('hindsight::install').that_comes_before('Class[hindsight::config]') }
    it { is_expected.to contain_class('hindsight::config') }
    it { is_expected.to contain_class('hindsight::service').that_requires('Class[hindsight::config]') }

    it { is_expected.to contain_service('hindsight') }
    it { is_expected.to contain_package('hindsight').with_ensure('installed') }

    it { is_expected.to contain_file('/etc/hindsight').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/hindsight/run').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/hindsight/run/input').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/hindsight/run/output').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/hindsight/run/analysis').with_ensure('directory') }
    it { is_expected.to contain_file('/var/cache/hindsight').with_ensure('directory') }
  end

  context 'allow passing pre-start commands' do
    let(:params) do
      {
        service_prestart: ['/bin/echo foo'],
      }
    end

    it {
      is_expected.to contain_service('hindsight')
        .that_subscribes_to('File[/etc/hindsight/hindsight.cfg]')
    }

    it do
      is_expected.to contain_file(
        '/lib/systemd/system/hindsight.service',
      ).with({
               'ensure' => 'file',
               'owner' => 'root',
               'group' => 'root',
               'mode' => '0644',
             }).with_content(%r{ExecStartPre=-/bin/echo foo})
    end
  end

  context 'paths to libraries' do
    it do
      is_expected.to contain_file(
        '/etc/hindsight/hindsight.cfg',
      ).with({
               'ensure' => 'file',
               'owner' => 'root',
               'group' => 'root',
               'mode' => '0644',
             }).with_content(%r{analysis_threads(\s+)=(\s+)1})
    end

    it do
      is_expected.to contain_file('/etc/hindsight/hindsight.cfg')
        .with_content(%r{analysis_lua_path(\s+)=(\s+)"/usr/(lib64|lib)/luasandbox/modules/\?.lua})
    end

    it {
      is_expected.to contain_exec('ldconfig_update')
        .that_subscribes_to('Package[hindsight]')
    }
  end

  context 'support defaults configuration' do
    let(:params) do
      {
        input_defaults: {
          'restricted_headers' => true,
        }
      }
    end

    it do
      is_expected.to contain_file(
        '/etc/hindsight/hindsight.cfg',
      ).with({
               'ensure' => 'file',
               'owner' => 'root',
               'group' => 'root',
               'mode' => '0644',
             }).with_content(%r{restricted_headers(\s+)=(\s+)true})
    end
  end

  context 'with hostname' do
    let(:params) do
      {
        hostname: 'test.localhost'
      }
    end

    it do
      is_expected.to contain_file(
        '/etc/hindsight/hindsight.cfg',
      ).with({
               'ensure' => 'file',
               'owner' => 'root',
               'group' => 'root',
               'mode' => '0644',
             }).with_content(%r{hostname(\s+)=(\s+)"test.localhost"})
    end
  end

  context 'with max_message_size' do
    let(:params) do
      {
        max_message_size: '15e6'
      }
    end

    it do
      is_expected.to contain_file(
        '/etc/hindsight/hindsight.cfg',
      ).with({
               'ensure' => 'file',
               'owner' => 'root',
               'group' => 'root',
               'mode' => '0644',
             }).with_content(%r{max_message_size(\s+)=(\s+)15e6})
    end
  end

  context 'with output_size' do
    let(:params) do
      {
        output_size: 128 * 1024 * 1024,
      }
    end

    it do
      is_expected.to contain_file(
        '/etc/hindsight/hindsight.cfg',
      ).with({
               'ensure' => 'file',
               'owner' => 'root',
               'group' => 'root',
               'mode' => '0644',
             }).with_content(%r{output_size(\s+)=(\s+)134217728})
    end
  end

  context 'package removal' do
    let(:params) do
      {
        package_ensure: 'absent'
      }
    end

    it { is_expected.to contain_file('/etc/hindsight').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/hindsight/run').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/hindsight/run/input').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/hindsight/run/output').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/hindsight/run/analysis').with_ensure('absent') }

    it { is_expected.to contain_package('hindsight').with_ensure('absent') }
    it { is_expected.to contain_service('hindsight').with_ensure('stopped') }
  end

  context 'unsupported operating system' do
    describe 'hindsight class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          os: {
            family: 'Solaris',
            name: 'Nexenta',
            distro: {
              codename: 'jessie'
            }
          },
        }
      end

      it { expect { is_expected.to contain_package('hindsight') }.to raise_error(Puppet::Error, %r{Nexenta not supported}) }
    end
  end
end
