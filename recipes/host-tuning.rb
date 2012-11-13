#
# Cookbook Name:: kvm
# recipe:: host-tuning
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 2012, Societe Publica.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "kvm::default"

include_recipe "sysctl"

include_recipe "modules"

if node[:cpu]["0"][:flags].include?("ept") and node['kernel']['release'] < "3.5"
  sysctl "vm.swappiness" do
    value "0"
    action :set
  end
end

modules "vhost_net"


include_recipe "sysfs"
#sysfs "Tuning ondemand cpufreq governor" do
#  name "devices/system/cpu/cpufreq/ondemand/sampling_down_factor"
#  value "100"
#end

## Don't change the cpu frequency.
# clock drift (in some cases)
# Drop performances http://lists.gnu.org/archive/html/qemu-devel/2012-03/msg00842.html
node.set["cpu"]["governor"] = "performance"
include_recipe "cpu"
