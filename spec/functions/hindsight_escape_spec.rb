#! /usr/bin/env ruby -S rspec
require 'spec_helper'
require 'rspec-puppet'

describe 'hindsight_escape' do

  describe 'escapes string' do
    it 'convert simple hash' do
      param = "foo"

      is_expected.to run.with_params(param).and_return("'foo'")
    end

    it 'should raise an error if run with extra arguments' do
      is_expected.to run.with_params(1, 2, 3, 4).and_raise_error(Puppet::ParseError)
    end

    it 'should raise an error with incorrect type of arguments' do
      is_expected.to run.with_params(1, 2).and_raise_error(Puppet::ParseError)
    end


  end

end
