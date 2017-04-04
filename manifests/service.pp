# == Class hindsight::service
#
# This class is meant to be called from hindsight.
# It ensure the service is running.
#
class hindsight::service {

  service { $::hindsight::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
