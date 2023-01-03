# == Class hindsight::install
# @summary
#  Ensures installation of system packages (RPM/deb/etc.)
#  This class is called from hindsight for install.
#
# @param package
#   Hindsight package name to be installed via system package
# @param modules
#   Optional modules (luasandbox extensions e.g. `['luasandbox-lpeg']`)
#
class hindsight::install (
  String        $package,
  Array[String] $modules,
) {
  ensure_packages(concat([$package], $modules))

  exec { 'ldconfig_update':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => 'ldconfig',
    subscribe   => Package[$package],
    refreshonly => true,
  }
}
