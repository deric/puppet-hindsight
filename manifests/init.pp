#
class hindsight (
  $package        = $::hindsight::params::package,
  $modules        = $::hindsight::params::modules,
  $user           = $::hindsight::params::user,
  $group          = $::hindsight::params::group,
  $service_name   = $::hindsight::params::service_name,
  $service_ensure = $::hindsight::params::service_ensure,
  $manage_service = $::hindsight::params::manage_service,
  $conf_dir       = $::hindsight::params::conf_dir,
  $output_dir     = $::hindsight::params::output_dir,
  $decoders_dir   = $::hindsight::params::decoders_dir,
  $run_dir        = $::hindsight::params::run_dir,
) inherits ::hindsight::params {

  validate_array($modules)

  class { '::hindsight::install':
    package => $package,
    modules => $modules,
  } ->
  class{'::hindsight::config':
    user       => $user,
    group      => $group,
    conf_dir   => $conf_dir,
    output_dir => $output_dir,
    run_dir    => $run_dir,
  }

  if $manage_service {
    class{'::hindsight::service':
      service => $service_name,
      ensure  => $service_ensure,
      require => [    Class['hindsight::config']],
    } ->
    Class['::hindsight']
  }

}