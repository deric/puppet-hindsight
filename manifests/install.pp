# == Class hindsight::install
#
# This class is called from hindsight for install.
#
class hindsight::install(
    $package,
    $modules,
  ) {

  ensure_packages(concat([$package], $modules))

}
