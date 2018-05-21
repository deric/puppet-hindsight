# Manages config directories
#
class hindsight::config (
  $user,
  $group,
  $conf_dir,
  $output_dir,
  $run_dir,
  $analysis_lua_path,
  $analysis_lua_cpath,
  $analysis_threads,
  $io_lua_path,
  $io_lua_cpath,
  $purge_configs,
  $analysis_defaults,
  $input_defaults,
  $output_defaults,
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
    recurse => $purge_configs,
    purge   => $purge_configs,
    require => File[$run_dir],
  }

  file { "${run_dir}/output":
    ensure  => 'directory',
    recurse => $purge_configs,
    purge   => $purge_configs,
    require => File[$run_dir],
  }

}
