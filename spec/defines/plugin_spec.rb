# frozen_string_literal: true

require 'spec_helper'

describe 'hindsight::plugin', :type => :define do
  let(:title) { 'debug' }

  let(:facts) do
    {
      :operatingsystem => 'Debian',
      :osfamily => 'Debian',
      :lsbdistcodename => 'jessie',
      :majdistrelease => '8',
      :operatingsystemmajrelease => 'jessie',
    }
  end
  let(:run_dir){ '/etc/hindsight/run' }

  context 'creates plugin config file' do
    let(:params) do
      {
        :filename => 'heka_debug.lua',
        :target => 'output/debug',
        :config => {
          'matcher' => "TRUE",
        },
        :manage_service => false,
        :service_name => 'hindsight',
        :run_dir => run_dir,
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_concat('/etc/hindsight/run/output/debug.cfg') }

    it {
      is_expected.to contain_concat__fragment(
        'debug'
      ).with_content(/matcher = 'TRUE'/)
    }
  end
end
