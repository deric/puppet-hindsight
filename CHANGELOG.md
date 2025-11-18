
## 2025-11-18 v1.2.0

 - Update supported OS
 - Support setting `output_size`

## 2025-11-07 v1.1.0

 - Support setting `max_message_size`

## 2024-06-22 v1.0.0

 - Require stdlib >= 9
 - Full Puppet 8 support

## 2024-02-14 v0.6.0

 - Puppet 8 support
 - Support stdlib 9.x, concat 9.x

## 2023-03-08 v0.5.1
 - Remove config directories when removing packages

## 2023-03-07 v0.5.0
 - Use hierarchical facts
 - Support package removal
 - Improve tests

## 2023-01-03 v0.4.0
 - Convert to PDK
 - Allow newer dependencies
 - Drop old distributions support
 - Execute ldconfig

## 2020-03-03 v0.3.0
 - Puppet 6 support
 - Enforce Puppet 4 types
 - Support a content or source argument for plugins (#2)
 - Drop Puppet 3 support

## 2018-05-18 v0.2.1/v0.2.2
 - Support purging config directories
 - Allow overriding analysis,input and output defaults

## 2018-03-03 v0.2.0
 - Path to libraries are configured based on distribution
 - Dropped testing for Puppet 3.4

## 2017-07-11 v0.1.2
 - Support pre-start commands for hindsight service

## 2017-07-11 v0.1.1
 - Escape Lua code with single quotes (temporary solution before we come up with something more robust)
 - Fixed starting Hindsight after network is ready (systemd)

## 2017-04-05 v0.1.0
 - initial module implementation
 - systemd service configuration
 - manages basic Hindsight plugins configuration
