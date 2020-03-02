# @summary
#   Hindsight plugin configuration
#
# @param filename
#   Name of Lua file to require
# @param target
#   Filename to write configuration (`.cfg` will be appended)
# @param ensure
#   Config file ensure (either `present` or `absent`)
# @param order
#   Concat order (in config file)
# @param config
#   Plugin configuration
# @param manage_service
#   When true Hindsight service will be restarted upon change
# @param service_name
#   Hindsight service name
# @param run_dir
#   sandbox_run directory
# @param content
#   Template to load config from
# @param source
#   Path from which config should be loaded
#
define hindsight::plugin (
  String                   $filename,
  String                   $target,
  Enum['present','absent'] $ensure         = 'present',
  Integer[1]               $order          = 1,
  Optional[Hash]           $config         = {},
  Boolean                  $manage_service = $::hindsight::manage_service,
  String                   $service_name   = $::hindsight::service_name,
  Stdlib::Absolutepath     $run_dir        = $::hindsight::run_dir,
  Optional[String]         $content        = undef,
  Optional[String]         $source         = undef,
){
  $path = "${run_dir}/${target}.cfg"

  if $ensure == 'present' {
    if !defined(Concat[$path]) {
      concat { $path:
        ensure => present,
        tag    => 'hindsight::plugin::file',
        warn   => false,
      }
      if $manage_service {
        Concat<| title == $path |> {
          notify => Service[$service_name]
        }
      }
    }

    concat::fragment { $title:
      target => $path,
      order  => $order,
    }

    if $content {
      Concat::Fragment<| title == $title |> {
        content => $content,
      }
    } elsif $source {
      Concat::Fragment<| title == $title |> {
        source => $source,
      }
    } else {
      Concat::Fragment<| title == $title |> {
        content =>  template('hindsight/plugin.cfg.erb'),
      }
    }

    if $manage_service {
      Concat::Fragment<| title == $title |> {
        notify => Service[$service_name]
      }
    }
  } else {
    file {$path:
      ensure => $ensure,
    }
  }
}
