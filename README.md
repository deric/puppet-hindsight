# puppet-hindsight

Module for managing Mozilla's Hindsight configuration and service.

## Related projects

  * [hindsight](https://github.com/mozilla-services/hindsight)
  * [lua_sandbox](https://github.com/mozilla-services/lua_sandbox)
  * [lua_sandbox_extensions](https://github.com/mozilla-services/lua_sandbox_extensions)

## Usage

All module names are expected to be available via package manager.

```puppet
  class{'::hindsight':
    modules => [ 'luasandbox','luasandbox-elasticsearch',
    'luasandbox-kafka','luasandbox-lpeg','luasandbox-systemd']
  }
```
plugin configuration:

```puppet
  hindsight::plugin {'tcp':
    filename => 'tcp.lua',
    target   => 'input/tcp',
    config   => {
      instruction_limit => 0,
      address => "0.0.0.0",
      port => 5858,
      keep_payload => false,
      send_decode_failures => true,
    }
  }
```
`target` is file location in `run_dir` without extension (`.cfg`).

The simplest plugin is probably `debug`:

```puppet
hindsight::plugin {'debug':
  filename => 'heka_debug.lua',
  target   => 'output/debug',
  config   => {
    message_matcher => 'TRUE',
  }
}
```
in order to disable plugin use `ensure => absent`:

```
  hindsight::plugin {'debug':
    ensure   => absent,
    filename => 'heka_debug.lua',
    target   => 'output/debug',
    config   => {
      message_matcher => 'TRUE',
    }
  }
```

