# Default param values
class hindsight::params {

  case $::osfamily {
    'Debian': {
      $package = 'hindsight'
      $service_name = 'hindsight'
      $analysis_lua_path = '/usr/lib/luasandbox/modules/?.lua'
      $analysis_lua_cpath = '/usr/lib/luasandbox/modules/?.so'
      $io_lua_path = '/usr/lib/luasandbox/io_modules/?.lua'
      $io_lua_cpath = '/usr/lib/luasandbox/io_modules/?.so'
    }
    'RedHat', 'Amazon': {
      $package = 'hindsight'
      $service_name = 'hindsight'
      $analysis_lua_path = '/usr/lib64/luasandbox/modules/?.lua'
      $analysis_lua_cpath = '/usr/lib64/luasandbox/modules/?.so'
      $io_lua_path = '/usr/lib64/luasandbox/io_modules/?.lua'
      $io_lua_cpath = '/usr/lib64/luasandbox/io_modules/?.so'
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
