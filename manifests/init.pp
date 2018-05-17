#
#
# [service_prestart] array of commands to be executed before hindsight service start
#
class hindsight (
  $package            = $::hindsight::params::package,
  $modules            = $::hindsight::params::modules,
  $user               = $::hindsight::params::user,
  $group              = $::hindsight::params::group,
  $service_name       = $::hindsight::params::service_name,
  $service_ensure     = $::hindsight::params::service_ensure,
  $manage_service     = $::hindsight::params::manage_service,
  $conf_dir           = $::hindsight::params::conf_dir,
  $output_dir         = $::hindsight::params::output_dir,
  $decoders_dir       = $::hindsight::params::decoders_dir,
  $run_dir            = $::hindsight::params::run_dir,
  $service_prestart   = [],
  $analysis_lua_path  = $::hindsight::params::analysis_lua_path,
  $analysis_lua_cpath = $::hindsight::params::analysis_lua_cpath,
  $analysis_threads   = 1,
  $io_lua_path        = $::hindsight::params::io_lua_path,
  $io_lua_cpath       = $::hindsight::params::io_lua_cpath,
  $purge_configs       = $::hindsight::params::purge_configs,
) inherits ::hindsight::params {

  validate_array($modules)

  class { '::hindsight::install':
    package => $package,
    modules => $modules,
  }
  -> class{'::hindsight::config':
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
  }

  if $manage_service {
    class{'::hindsight::service':
      service  => $service_name,
      ensure   => $service_ensure,
      prestart => $service_prestart,
      conf_dir => $conf_dir,
      require  => [Class['hindsight::config']],
    }
    -> Class['::hindsight']
  }

}
