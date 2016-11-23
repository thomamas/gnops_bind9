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

require 'spec_helper'

describe port(53) do
  it { should be_listening.with('tcp') }
  it { should be_listening.with('udp') }
end

describe service('bind9') do
  it { should be_enabled }
  it { should be_running }
end

describe command('dig @127.0.0.1 google.com') do
  its(:stdout) { should match(/status: NOERROR/) }
end

describe command('dig @127.0.0.1 www.example.com') do
  its(:stdout) { should match(/status: NOERROR/) }
end

describe command('dig @127.0.0.1 www.internal.example.com') do
  its(:stdout) { should match(/CNAME.*webprod1.internal.example.com./) }
  its(:stdout) { should match(/status: NOERROR/) }
end

describe command('dig @127.0.0.1 ec2.amazonaws.com') do
  its(:stdout) { should match(/status: NOERROR/) }
end

# this should come after at least one lookup
describe file('/var/log/named/queries') do
  its(:size) { should > 1 }
end
