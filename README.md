# gnops\_bind9 cookbook

Installs and configures a BIND 9 server. We assume the reader is familiar with Chef configuration management. The term "gnops" used throughout the cookbook stands for Gracenote Operations.

## Supported Platforms

Ubuntu 14.04 LTS and newer, but other Debian family operating systems are likely to work.

## Attributes

* `node['gnops']['bind9']['internal_nets']` - List of networks used to define the internal view. Default is RFC1918 plus localhost.
* `node['gnops']['bind9']['ipv4_only']` - Disable IPv6 in BIND. Probably only needed for hosts where IPv6 is enabled but the network doesn't actually support it. Default is true.
* `node['gnops']['bind9']['forward_default']` - For unknown domains, should BIND work as a forwarding nameserver instead of doing its own recursive lookups? Default is true.
* `node['gnops']['bind9']['forward_upstream']` - Where to forward. Default is `169.254.169.253`.
* `node['gnops']['bind9']['groups']` - A dictionary where the keys are the names of groups of domains, and the values are dictionaries with the following keys:
  * `domains` - List of domains. Mandatory.
  * `masters` - List of name servers that can answer for those domains. Mandatory.
  * `forward` - Act as a forwarder instead of a slave for these domain? Default is false.
  * `public`  - Publish in the public view as well as the internal view.

An example of the `groups` configuration:

    default['gnops']['bind9']['groups'] = {
      'internal' => {
        'masters' => ['10.10.10.4', '10.10.10.5'],
        'domains' => ['internal.example.com', 'dev.example.com'],
      },
      'public' => {
        'masters' => ['172.16.0.4', '172.16.0.5'],
        'domains' => ['example.com']
        'public' => true
      }
    }

## Usage

Include `gnops_bind9::default` in your node's `run_list` and set the necessary attributes.

## License and Authors

Author: Thomas Insel (<tinsel@gracenote.com>) for Gracenote.

Copyright (C) 2016 Gracenote

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
