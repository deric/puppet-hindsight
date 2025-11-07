# @summary
#   Internal class, should not be called directly.
#   Manages directory structure for Hindsight configuration files
#
# @param user
#   The owner of config files
# @param group
#   The group for config files
# @param conf_dir
#   Directory where main Hidsight configuration resides
# @param output_dir
#   Path where the protobuf streams, checkpoints and statistics are stored.
# @param run_dir
#   Base path containing the running configis and dynamically loaded lua, by default `conf_dir/run`
# @param analysis_lua_path
#   Path used by the analysis plugins to look for Lua modules
# @param analysis_lua_cpath
#   Path used by the analysis plugins to look for Lua C modules
# @param io_lua_path
#   Path to look for Lua io modules
# @param io_lua_cpath
#   Path to look for C io modules
# @param analysis_threads
#   Number of threads for analysis
# @param purge_configs
#   Removed configs that are not managed by this module
# @param analysis_defaults
#   Hash overriding default sandbox configuration variables. See https://mozilla-services.github.io/hindsight/configuration.html
# @param input_defaults
#   Hash overriding default sandbox configuration variables. See https://mozilla-services.github.io/hindsight/configuration.html
# @param output_defaults
#   Hash overriding default sandbox configuration variables. See https://mozilla-services.github.io/hindsight/configuration.html
# @param file_ensure
#   Ensure passed to config files
# @param dir_ensure
#   Ensure passed to directories
# @param hostname
#   Manually set hostname
class hindsight::config (
  String               $user,
  String               $group,
  Stdlib::Absolutepath $conf_dir,
  Stdlib::Absolutepath $output_dir,
  Stdlib::Absolutepath $run_dir,
  Stdlib::Absolutepath $analysis_lua_path,
  Stdlib::Absolutepath $analysis_lua_cpath,
  Integer              $analysis_threads,
  Stdlib::Absolutepath $io_lua_path,
  Stdlib::Absolutepath $io_lua_cpath,
  Boolean              $purge_configs,
  Hash                 $analysis_defaults,
  Hash                 $input_defaults,
  Hash                 $output_defaults,
  Optional[String]     $hostname,
  String               $file_ensure = 'file',
  String               $dir_ensure = 'directory',
) {
  File {
    owner   => $user,
    group   => $group,
    mode    => '0644',
  }

  file { $conf_dir:
    ensure => $dir_ensure,
  }

  file { $output_dir:
    ensure => $dir_ensure,
  }

  file { "${conf_dir}/hindsight.cfg":
    ensure  => $file_ensure,
    content => template('hindsight/hindsight.cfg.erb'),
    require => File[$conf_dir],
  }

  file { $run_dir:
    ensure  => $dir_ensure,
    require => File[$conf_dir],
  }

  file { "${run_dir}/analysis":
    ensure  => $dir_ensure,
    require => File[$run_dir],
  }

  file { "${run_dir}/input":
    ensure  => $dir_ensure,
    recurse => $purge_configs,
    purge   => $purge_configs,
    require => File[$run_dir],
  }

  file { "${run_dir}/output":
    ensure  => $dir_ensure,
    recurse => $purge_configs,
    purge   => $purge_configs,
    require => File[$run_dir],
  }
}
