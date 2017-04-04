class hindsight::config (
  $user,
  $group,
  $conf_dir,
  $output_dir,
  $run_dir,
  ){

  File {
    owner   => $user,
    group   => $group,
    mode    => '0644',
  }

  file { $conf_dir:
    ensure  => 'directory',
  }

  file { $output_dir:
    ensure  => 'directory',
  }

  file { "${conf_dir}/hindsight.cfg":
    ensure  => 'present',
    content => template('hindsight/hindsight.cfg.erb'),
    require => File[$conf_dir],
  }

  file { $run_dir:
    ensure  => 'directory',
    require => File[$conf_dir],
  }

  file { "${run_dir}/analysis":
    ensure  => 'directory',
    require => File[$run_dir],
  }

  file { "${run_dir}/input":
    ensure  => 'directory',
    require => File[$run_dir],
  }

  file { "${run_dir}/output":
    ensure  => 'directory',
    require => File[$run_dir],
  }

}
