# Class: hindsight
# ===========================
#
# Full description of class hindsight here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class hindsight (
  $package_name = $::hindsight::params::package_name,
  $service_name = $::hindsight::params::service_name,
) inherits ::hindsight::params {

  # validate parameters here

  class { '::hindsight::install': } ->
  class { '::hindsight::config': } ~>
  class { '::hindsight::service': } ->
  Class['::hindsight']
}
