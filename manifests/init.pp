# @summary
#   Manage Hidsight service configuration
#
# @param max_message_size max size in bytes default: 8e6 (8MB)
# @param package
#   Hindsight package name to be installed via system package
# @param modules
#   Optional modules (luasandbox extensions e.g. `['luasandbox-lpeg']`)
# @param user
#   The owner of config files
# @param group
#   The group for config files
# @param service_name
#   Name of service running Hindsight daemon
# @param service_ensure
#   Possible values `running`,`stoppped`,`true`, `false`
# @param manage_service
#   Whether Puppet should manage the service
# @param service_prestart
#   Array of commands to be executed before hindsight service start
# @param service_nofile
#   Limit number of opened file descriptors
# @param conf_dir
#   Directory where main Hidsight configuration resides
# @param output_dir
#   Path where the protobuf streams, checkpoints and statistics are stored.
# @param decoders_dir
#   Path to decoders
# @param run_dir
#   Base path containing the running configis and dynamically loaded lua, by default `conf_dir/run`
# @param analysis_lua_path
#   Path used by the analysis plugins to look for Lua modules
# @param analysis_lua_cpath
#   Path used by the analysis plugins to look for Lua C modules
# @param purge_configs
#   Removed configs that are not managed by this module
# @param analysis_threads
#   Number of threads for analysis
# @param io_lua_path
#   Path to look for Lua io modules
# @param io_lua_cpath
#   Path to look for C io modules
# @param analysis_defaults
#   Hash overriding default sandbox configuration variables. See https://mozilla-services.github.io/hindsight/configuration.html
# @param input_defaults
#   Hash overriding default sandbox configuration variables. See https://mozilla-services.github.io/hindsight/configuration.html
# @param output_defaults
#   Hash overriding default sandbox configuration variables. See https://mozilla-services.github.io/hindsight/configuration.html
# @param package_ensure
#   Ensure passed to installed packages
# @param hostname
#   Manually set hostname
# @param output_size in bytes (default 64MiB)
class hindsight (
  String                  $max_message_size,
  String                  $package            = $hindsight::params::package,
  Array[String]           $modules            = $hindsight::params::modules,
  String                  $user               = $hindsight::params::user,
  String                  $group              = $hindsight::params::group,
  String                  $service_name       = $hindsight::params::service_name,
  Variant[Boolean,String] $service_ensure     = $hindsight::params::service_ensure,
  Boolean                 $manage_service     = $hindsight::params::manage_service,
  Array[String]           $service_prestart   = [],
  Optional[String]        $service_nofile     = undef,
  Stdlib::Absolutepath    $conf_dir           = $hindsight::params::conf_dir,
  Stdlib::Absolutepath    $output_dir         = $hindsight::params::output_dir,
  Stdlib::Absolutepath    $decoders_dir       = $hindsight::params::decoders_dir,
  Stdlib::Absolutepath    $run_dir            = $hindsight::params::run_dir,
  Stdlib::Absolutepath    $analysis_lua_path  = $hindsight::params::analysis_lua_path,
  Stdlib::Absolutepath    $analysis_lua_cpath = $hindsight::params::analysis_lua_cpath,
  Integer                 $analysis_threads   = 1,
  Stdlib::Absolutepath    $io_lua_path        = $hindsight::params::io_lua_path,
  Stdlib::Absolutepath    $io_lua_cpath       = $hindsight::params::io_lua_cpath,
  Boolean                 $purge_configs      = $hindsight::params::purge_configs,
  Hash                    $analysis_defaults  = $hindsight::params::analysis_defaults,
  Hash                    $input_defaults     = $hindsight::params::input_defaults,
  Hash                    $output_defaults    = $hindsight::params::output_defaults,
  Integer                 $output_size        = 64 * 1024 * 1024,
  String                  $package_ensure     = 'installed',
  Optional[String]        $hostname           = undef,
) inherits hindsight::params {
  class { 'hindsight::install':
    package        => $package,
    modules        => $modules,
    package_ensure => $package_ensure,
  }

  $_dir_ensure = $package_ensure ? {
    'absent' => 'absent',
    default  => 'directory',
  }

  $_file_ensure = $package_ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }

  class { 'hindsight::config':
    user               => $user,
    group              => $group,
    conf_dir           => $conf_dir,
    output_dir         => $output_dir,
    run_dir            => $run_dir,
    analysis_lua_path  => $analysis_lua_path,
    analysis_lua_cpath => $analysis_lua_cpath,
    analysis_threads   => $analysis_threads,
    io_lua_path        => $io_lua_path,
    io_lua_cpath       => $io_lua_cpath,
    purge_configs      => $purge_configs,
    analysis_defaults  => $analysis_defaults,
    input_defaults     => $input_defaults,
    output_defaults    => $output_defaults,
    output_size        => $output_size,
    dir_ensure         => $_dir_ensure,
    file_ensure        => $_file_ensure,
    hostname           => $hostname,
    max_message_size   => $max_message_size,
    require            => Class['hindsight::install'],
  }

  if $manage_service {
    $_service_ensure = $package_ensure ? {
      'absent' => 'stopped',
      default  => $service_ensure,
    }
    class { 'hindsight::service':
      service  => $service_name,
      ensure   => $_service_ensure,
      prestart => $service_prestart,
      nofile   => $service_nofile,
      conf_dir => $conf_dir,
      require  => [Class['hindsight::config']],
    }
    -> Class['hindsight']
  }
}
