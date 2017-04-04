# == Class hindsight::params
#
# This class is meant to be called from hindsight.
# It sets variables according to platform.
#
class hindsight::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'hindsight'
      $service_name = 'hindsight'
    }
    'RedHat', 'Amazon': {
      $package_name = 'hindsight'
      $service_name = 'hindsight'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
