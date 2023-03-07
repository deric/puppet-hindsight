# @summary
#  Manage Hindsight service
#
# @param service
#   Name of service running Hindsight daemon
# @param ensure
#    Possible values `running`,`stoppped`,`true`, `false`
# @param conf_dir
#   Directory where main Hidsight configuration resides
# @param prestart
#   Array of commands to be executed before hindsight service start
#
class hindsight::service (
  String                  $service,
  Variant[Boolean,String] $ensure,
  Stdlib::Absolutepath    $conf_dir,
  Array[String]           $prestart = [],
) {
  # service configuration
  file { '/lib/systemd/system/hindsight.service':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('hindsight/service.erb'),
    notify  => Exec['systemd_update'],
  }

  file { '/etc/systemd/system/multi-user.target.wants/hindsight.service':
    ensure  => 'link',
    target  => '/lib/systemd/system/hindsight.service',
    require => File['/lib/systemd/system/hindsight.service'],
  }

  exec { 'systemd_update':
    command     => 'systemctl daemon-reload',
    path        => '/bin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }

  service { $service:
    ensure     => $ensure,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => [
      File['/lib/systemd/system/hindsight.service']
    ],
    subscribe  => [
      File['/lib/systemd/system/hindsight.service'],
      File["${conf_dir}/hindsight.cfg"],
    ],
  }
}
