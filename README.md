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

```
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


