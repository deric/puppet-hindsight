# == Class hindsight::install
# @summary
#  Ensures installation of system packages (RPM/deb/etc.)
#  This class is called from hindsight for install.
#
# @param package
#   Hindsight package name to be installed via system package
# @param modules
#   Optional modules (luasandbox extensions e.g. `['luasandbox-lpeg']`)
# @param package_ensure
#   Common ensure for all packages, e.g.: present | absent
#
class hindsight::install (
  String        $package,
  Array[String] $modules,
  String        $package_ensure = 'installed',
) {
  ensure_packages(concat([$package], $modules), { 'ensure' => $package_ensure })

  exec { 'ldconfig_update':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => 'ldconfig',
    subscribe   => Package[$package],
    refreshonly => true,
  }
}
