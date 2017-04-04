# == Class hindsight::install
#
# This class is called from hindsight for install.
#
class hindsight::install {

  package { $::hindsight::package_name:
    ensure => present,
  }
}
