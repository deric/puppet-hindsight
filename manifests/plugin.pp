# [*filename*] Lua file require
#
#
define hindsight::plugin (
  $filename,
  $target,
  $ensure = 'present',
  $order = 1,
  $config = {},
  $manage_service = $::hindsight::manage_service,
  $service_name   = $::hindsight::service_name,
  $run_dir        = $::hindsight::run_dir,
  $content        = undef,
  $source         = undef,
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

    # if one gives a CONTENT or SOURCE arg, take that
    if $content != undef or $source != undef {
      concat::fragment { $title:
        target  => $path,
        content => $content,
        source  => $source,
        order   => $order;
      }
    } else {
      concat::fragment { $title:
        target  => $path,
        content =>  template('hindsight/plugin.cfg.erb'),
        order   => $order;
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
