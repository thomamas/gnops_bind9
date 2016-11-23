#
# Copyright (C) 2016 Gracenote
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default['gnops']['bind9']['ipv4_only'] = true
default['gnops']['bind9']['forward_default'] = true
default['gnops']['bind9']['forward_upstream'] = '169.254.169.253'

default['gnops']['bind9']['internal_nets'] = [
  '10/8',
  '172.16/12',
  '192.168/16',
  '127.0.0.1',
  '::1'
]

default['gnops']['bind9']['groups'] = {
  'ops' => {
    'masters' => [
      '10.10.128.4',
      '10.10.128.5'
    ],
    'domains' => [
      'internal.example.com'
    ]
  },

  'opspub' => {
    'masters' => [
      '10.10.192.4',
      '10.10.192.5'
    ],
    'domains' => [
      'example.com'
    ],
    'public' => true
  }
}
