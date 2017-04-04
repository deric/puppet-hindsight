# Default param values
class hindsight::params {

  case $::osfamily {
    'Debian': {
      $package = 'hindsight'
      $service_name = 'hindsight'
    }
    'RedHat', 'Amazon': {
      $package = 'hindsight'
      $service_name = 'hindsight'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $modules        = []
  $service_ensure = 'running'
  $user           = 'root'
  $group          = 'root'
  $conf_dir       = '/etc/hindsight'
  $output_dir     = '/var/cache/hindsight/'
  $manage_service = true
  $decoders_dir   = '/usr/lib/luasandbox/io_modules/decoders'
  $run_dir        = "${conf_dir}/run"
}