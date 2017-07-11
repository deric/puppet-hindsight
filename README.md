# puppet-hindsight

[![Puppet
Forge](http://img.shields.io/puppetforge/v/deric/hindsight.svg)](https://forge.puppetlabs.com/deric/hindsight) [![Build Status](https://travis-ci.org/deric/puppet-hindsight.svg?branch=master)](https://travis-ci.org/deric/puppet-hindsight) [![Puppet Forge
Downloads](http://img.shields.io/puppetforge/dt/deric/hindsight.svg)](https://forge.puppetlabs.com/deric/hindsight/scores)

Module for managing Mozilla's Hindsight configuration and service.

## Related projects

Hindsight is a log forwarding engine (successor of Mozilla's Heka) implemented in low-level C with Lua scripting support.

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

```puppet
  hindsight::plugin {'debug':
    ensure   => absent,
    filename => 'heka_debug.lua',
    target   => 'output/debug',
  }
```

## Service pre-start commands

Before starting Hindsight service custom commands can be provided:

```puppet
  class{'::hindsight':
    service_prestart => [ '/bin/echo foo', '/bin/echo bar']
  }
```
