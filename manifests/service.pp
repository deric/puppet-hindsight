class hindsight::service (
  $service,
  $ensure,
  ){

    # service configuration
  file { '/lib/systemd/system/hindsight.service':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('hindsight/service.erb'),,
    notify  => Exec['systemd_update'],
  }

  file { '/etc/systemd/system/multi-user.target.wants/hindsight.service':
    ensure  => 'link',
    target  => '/lib/systemd/system/hindsight.service',
    require => File['/lib/systemd/system/hindsight.service'],
  }

  exec { 'systemd_update':
    command      => 'systemctl daemon-reload',
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
      File['/lib/systemd/system/hindsight.service']
    ]
  }

}