source "https://rubygems.org"

group :test do
  gem 'librarian-puppet' , '>=2.0'
  gem "metadata-json-lint"
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 4.4.0'
  gem "puppetlabs_spec_helper"
  gem "rake", '< 12.0'
  gem "rspec", '< 3.2.0'
  gem "rspec-puppet", '>= 2.5.0'
  gem "rspec-puppet-facts"
  gem 'rubocop', '> 0.33.0'
  gem 'simplecov', '>= 0.11.0'
  gem 'simplecov-console'

  gem "puppet-lint-absolute_classname-check"
  gem "puppet-lint-classes_and_types_beginning_with_digits-check"
  gem "puppet-lint-leading_zero-check"
  gem 'puppet-lint-resource_reference_syntax'
  gem "puppet-lint-trailing_comma-check"
  gem "puppet-lint-unquoted_string-check"
  gem "puppet-lint-version_comparison-check"
  if RUBY_VERSION >= "2.2.0"
    gem 'safe_yaml'
  end
end

group :development do
  gem "guard-rake"
  gem "puppet-blacksmith"
  gem "travis"
  gem "travis-lint"
end

group :system_tests do
  gem "beaker"
  gem "beaker-puppet_install_helper"
  gem "beaker-rspec"
end
